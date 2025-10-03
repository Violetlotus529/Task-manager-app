# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
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
      flash.now[:aleart] = 'エラーが発生しました。'
      render :new
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
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

  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline)
  end
end
