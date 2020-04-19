class CachePage
  def initialize(url)
    @id = url
  end

  def key
    "cache_page:" + @id
  end

  def title
    $redis_pages.hget(key, 'title')
  end

  def updated_at
    $redis_pages.hget(key, 'updated_at')
  end

  def host
    uri = URI(@id)
    "#{uri.scheme}://#{uri.host}"
  end

  def to_h
    hash = $redis_pages.hgetall(key) || {}
    hash.merge(
      'host' => host,
      'favicon' => host + '/favicon.ico'
    )
  end

  def reload
    @page = Page.find_by_url(@id)
    doc = Nokogiri::HTML(@page.cached_page_file)

    $redis_pages.hset(key, 'title', doc.title)
    $redis_pages.hset(key, 'updated_at', @page.updated_at)

    self
  end


  def self.each
    $redis_pages.scan_each(match: "cache_page:*") do |key|
      yield CachePage.new key.gsub(/^cache_page:/, "")
    end
  end

  def self.all(count: nil)
    cache_pages = []
    each do |cache_page|
      cache_pages << cache_page
      break if (count && cache_pages.count > count)
    end
    cache_pages
  end

  def self.find(url)
    $redis_pages.exists("cache_page:#{url}") ? CachePage.new(url) : nil
  end

  def self.count
    counter = 0
    $redis_pages.scan_each(match: "cache_page:*") do
      counter += 1
    end
    counter
  end
end