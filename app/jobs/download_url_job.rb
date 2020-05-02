class DownloadUrlJob < ApplicationJob
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Don't retry this job if we can't get to the page
  discard_on Mechanize::RobotsDisallowedError, Mechanize::ResponseCodeError

  # Trigger download of a URL.  Only do this if you're sure you want to download it, since
  # no checks will be performed
  def perform(url, page = nil)
    begin
      page_file_io = download_page(url)
    rescue Mechanize::RobotsDisallowedError, Mechanize::ResponseCodeError => e
      if page
        page.download_invalid = DateTime.now.utc
        page.save
      end

      raise
    end

    page ||= Page.create_or_find_by!(url: url)

    attach_page_file(page, page_file_io)
  rescue

  end

  def attach_page_file(page, page_file_io)
    page.page_file.attach io: page_file_io, filename: page.url
    page.download_success = DateTime.now.utc
    page.extract_page_links

    page.save
  end

  def download_page(url)
    mechanize_agent = Mechanize.new
    mechanize_agent.history.max_size = 5 # default is 50
    mechanize_agent.robots = true

    mechanize_page = mechanize_agent.get(url)
    raise 'Page is nil' if mechanize_page.nil?
    raise 'Only html pages are supported' unless mechanize_page.is_a?(Mechanize::Page)

    StringIO.new mechanize_page.body.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
  end
end
