class CachePageJob < ApplicationJob
  def perform(page)
    page = Page.find page unless page.is_a?(Page)

    cache_page = CachePage.new page.url
    cache_page.reload
  end
end
