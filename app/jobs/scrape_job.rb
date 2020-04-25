class ScrapeJob < ApplicationJob
  retry_on ActiveRecord::Deadlocked
  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  def perform
    Website.should_scrape.scrape_unlocked
      .in_batches.each_record do |website|
      page_to_scrape = website.pages.sort_by {|page| page.download_success || 0}.first
      ScrapeDownloadJob.perform_now(page_to_scrape)
    end

  end
end
