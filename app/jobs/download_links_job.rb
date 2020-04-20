class DownloadLinksJob < ApplicationJob
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  # NOTE: This job currently will remove the query and fragment portion of urls.
  def perform(page)
    page = Page.find page unless page.is_a?(Page)

    page.download_page_file unless page.cached_page_file

    # TODO: make this configurable. For now, we remove any url params and url fragment
    links_to_download = page.reload.links.map do |link|
      uri = URI(link)
      uri.query = nil
      uri.fragment = nil
      uri.to_s
    end

    links_to_download.each do |link|
      process_link(link)
    end
  end

  def process_link(link_string)
    link_page = Page.create_or_find_by!(url: link_string)
    link_page.download_page_file unless link_page.cached_page_file

    ExtractWordsJob.perform_later(link_page)
    CachePageJob.perform_later(link_page)
  rescue Page::FetchInvalidError
  end

end
