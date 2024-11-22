class Task < ApplicationRecord
  STATUSES = %w[pending in_progress completed failed].freeze
  TASK_TYPES = %w[web_scraping generic].freeze

  validates :title, presence: true, length: { maximum: 100 }
  validates :status, inclusion: { in: STATUSES }
  validates :task_type, inclusion: { in: TASK_TYPES }
  validates :url, presence: true, if: :web_scraping?

  private

  def web_scraping?
    task_type == 'web_scraping'
  end
end
