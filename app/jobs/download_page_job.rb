class DownloadPageJob < ApplicationJob
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  def perform(page, extract_words_now = false)
    page = Page.find page unless page.is_a?(Page)

    page.download_page_file unless page.cached_page_file

    if extract_words_now
      ExtractWordsJob.perform_now(page)
    else
      ExtractWordsJob.perform_later(page)
    end
  end

end
