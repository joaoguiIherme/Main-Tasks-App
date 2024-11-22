class ScrapingServiceClient
  BASE_URL = 'http://scraping_service:4002'

  def perform_scraping(url, task_id)
    response = HTTP.post("#{BASE_URL}/scraping_tasks", json: { url: url, task_id: task_id })
    raise "Failed to send scraping task: #{response.status}" unless response.status.success?

    response.parse
  end
end
