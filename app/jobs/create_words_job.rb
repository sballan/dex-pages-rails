class CreateWordsJob < ApplicationJob
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  def perform
    Page.only_with_page_file.in_batches.each_record do |page|
      ExtractWordsJob.perform_later page
    end
  end

end
