class Word

  def initialize(word_string)
    @value = word_string
  end

  def id
    "word:" + @value
  end

  def set_page(url, data)
    $redis_words.hset(id, url, data.to_json)
  end

  def get_page(url)
    JSON.parse($redis_words.hget(id, url))
  end

  def self.each
    $redis_words.scan_each(match: "word:*") do |word_value|
      yield Word.new word_value.gsub(/^word:/, "")
    end
  end

  def self.count
    counter = 0
    $redis_words.scan_each(match: "word:*") do |word_value|
      counter += 1
    end
    counter
  end
end