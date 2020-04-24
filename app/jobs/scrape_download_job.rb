class ScrapeDownloadJob < ApplicationJob
  retry_on ActiveRecord::Deadlocked
  discard_on Mechanize::RobotsDisallowedError, Mechanize::ResponseCodeError

  def perform(page)
    page = Page.find page unless page.is_a?(Page)

    page_file_io = download_page(page)
    page.page_file.attach io: page_file_io, filename: page.url
    page.download_success = DateTime.now.utc

    page.save!

    ExtractWordsJob.perform_later(page)
    CachePageJob.perform_later(page)
  end

  def download_page(page)
    mechanize_agent = Mechanize.new
    mechanize_agent.history.max_size = 5 # default is 50
    mechanize_agent.robots = true

    mechanize_page = mechanize_agent.get(page.url)
    raise 'Page is nil' if mechanize_page.nil?
    raise 'Only html pages are supported' unless mechanize_page.is_a?(Mechanize::Page)

    StringIO.new mechanize_page.body.encode(
      'UTF-8', invalid: :replace, undef: :replace, replace: ''
    )
  rescue Mechanize::RobotsDisallowedError, Mechanize::ResponseCodeError => e
    page.download_invalid = DateTime.now.utc
    page.save

    raise
  end
end
