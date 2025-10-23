# frozen_string_literal: true

class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:toggle_completed]
  def index
    @tasks = Task.all
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @tasks = @tasks.where(
        'title LIKE ? OR content LIKE ?',
        search_term, search_term
      )
    end
    case params[:filter]
    when 'today'
      @tasks = @tasks.where(deadline: Date.current)
    when 'this_week'
      start_date = Date.current.beginning_of_week
      end_date = Date.current.end_of_week
      @tasks = @tasks.where(deadline: start_date..end_date)
    when 'overdue'
      @tasks = @tasks.where('deadline < ?', Date.current)
    end
    @tasks = @tasks.where(status: params[:status]) if params[:status].present?
    @tasks = @tasks.where(priority: params[:priority]) if params[:priority].present?
    @tasks = case params[:sort]
             when 'deadline'
               @tasks.order(:deadline)
             when 'priority'
               @tasks.order(priority: :desc)
             else
               @tasks.order(created_at: :desc)
             end
    @tasks = @tasks.page(params[:page]).per(5)
    @tasks_by_date = @tasks.group_by { |task| task.deadline }
  end

  def show
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = '編集しようとしたページが見つかりません'
    redirect_to tasks_path
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: 'タスクを正常に保存できました'
    else
      flash.now[:alert] = 'エラーが発生しました。'
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      flash.now[:alert] = '更新に失敗しました。入力内容を確認してください。'
      render :edit
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = '更新しようとしたタスクが見つかりません'
    redirect_to tasks_path
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully deleted.'
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = '削除しようとしたタスクが見つかりません'
    redirect_to task_path
  end

  def toggle_completed
    @task = Task.find(params[:id])
    @task.update(completed: !@task.completed)
    redirect_to tasks_path
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'タスクが見つかりません'
    redirect_to tasks_path
  end

  def toggle_status
    @task = Task.find(params[:id])
    case @task.status
    when 'not_started'
      @task.in_progress!
    when 'in_progress'
      @task.completed!
    when 'completed'
      @task.not_started!
    end
    redirect_to tasks_path
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'タスクが見つかりません'
    redirect_to tasks_path
  end

  # GET /tasks/:id/confirm_delete
  def confirm_delete
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'タスクが見つかりません'
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end
end
