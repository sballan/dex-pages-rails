class DownloadLinksJob < ApplicationJob
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  def perform(page, should_extract_words = true)
    page = Page.find page unless page.is_a?(Page)

    page.download_page_file unless page.cached_page_file

    page.reload.links.each do |link|
      link_page = Page.create_or_find_by!(url: link)
      link_page.download_page_file unless link_page.cached_page_file
      ExtractWordsJob.perform_later(link_page) if should_extract_words
    rescue Page::FetchInvalidError
    end
  end

end
