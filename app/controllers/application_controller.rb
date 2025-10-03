class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    flash[:alert] = 'お探しのタスクが見つかりませんでした。'
    redirect_to tasks_path
  end
end
