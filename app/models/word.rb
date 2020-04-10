class Word

  def initialize(id)
    @id = id
  end

  def key
    "word:" + @id
  end

  def set_page(url, data)
    $redis_words.hset(key, url, data.to_json)
  end

  def get_page(url)
    $redis_words.hget(key, url)
  end

  def get_all_pages
    $redis_words.hgetall(key)
  end

  def to_h
    res = get_all_pages
    res.each do |key, value|
      res[key] = JSON.parse(value)
    end
  end

  def self.each
    $redis_words.scan_each(match: "word:*") do |key|
      yield Word.new key.gsub(/^word:/, "")
    end
  end

  def self.all(count: nil)
    words = []
    each do |word|
      words << word
      break if (count && words.count > count)
    end
    words
  end

  def self.find(id)
    $redis_words.exists("word:#{id}") ? Word.new(id) : nil
  end

  def self.count
    counter = 0
    $redis_words.scan_each(match: "word:*") do
      counter += 1
    end
    counter
  end
end