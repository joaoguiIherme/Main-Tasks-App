class NotificationsController < ApplicationController

  def index
    begin
      response = RestClient.get("http://notifications_service:4001/notifications")
      @notifications = JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.error "Erro ao buscar notificações: #{e.response}"
      render json: { error: 'Erro ao buscar notificações' }, status: :internal_server_error
    rescue StandardError => e
      Rails.logger.error "Erro inesperado: #{e.message}"
      render json: { error: 'Erro inesperado ao buscar notificações' }, status: :internal_server_error
    end
  end

  # POST /notifications/update_task_status
  def update_task_status
    task_id = params[:task_id]
    event_type = params[:event_type]

    task = Task.find_by(id: task_id)

    if task.nil?
      render json: { error: 'Task not found' }, status: :not_found
      return
    end

    case event_type
    when 'scrape_completed'
      task.update(status: 'completed')
      render json: { message: 'Task status updated to completed' }, status: :ok
    when 'scrape_failed'
      task.update(status: 'failed')
      render json: { message: 'Task status updated to failed' }, status: :ok
    else
      render json: { error: 'Invalid event type' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("Error updating task status: #{e.message}")
    render json: { error: 'Error updating task status' }, status: :internal_server_error
  end
end
