class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  # skip_before_action :verify_authenticity_token, only: :update_status # Para permitir requisições externas

  # GET /tasks
  def index
    @tasks = Task.all.group_by(&:status)
  end
  

  # GET /tasks/:id
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      handle_web_scraping_task(@task) if @task.task_type == 'web_scraping'
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # POST /tasks/update_status
  def update_status
    task = Task.find_by(id: params[:task_id])

    if task
      task.update(status: params[:status])
      render json: { message: 'Task status updated successfully' }, status: :ok
    else
      render json: { error: 'Task not found' }, status: :not_found
    end
  end


  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      handle_web_scraping_task(@task) if @task.task_type == 'web_scraping'
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/:id
  def destroy
    @task.destroy
    head :no_content
  end

  private

  # Busca e define a tarefa antes de ações específicas
  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task not found' }, status: :not_found
  end

  # Permite apenas os parâmetros necessários
  def task_params
    params.require(:task).permit(:title, :description, :status, :task_type, :url)
  end

  # Lida com tarefas de web scraping
  def handle_web_scraping_task(task)
    # Integração com o micro serviço de scraping
    ScrapingServiceClient.new.perform_scraping(task.url, task.id)
  rescue StandardError => e
    Rails.logger.error("Failed to send web scraping task: #{e.message}")
  end
end
