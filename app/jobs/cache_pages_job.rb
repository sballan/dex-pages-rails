class CachePagesJob < ApplicationJob
  def perform
    Page.only_with_page_file.in_batches.each_record do |page|
      cache_page = CachePage.new page.url
      cache_page.reload
    end
  end
end
