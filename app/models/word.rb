class Word
  include Redis::Objects

  hash_key :appearances

  def initialize(word_string)
    @value = word_string
  end

  # We need an id for Redis::Objects to work
  def id
    @value
  end

  def set_appearance(url, page_data)
    appearances[url] = page_data.to_json
  end

  def get_appearance(url)
    JSON.parse(appearances[url])
  end
end