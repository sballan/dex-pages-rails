class CachePagesJob < ApplicationJob
  def perform
    Page.only_with_page_file.in_batches.each_record do |page|
      CachePageJob.perform_later(page)
    end
  end
end
