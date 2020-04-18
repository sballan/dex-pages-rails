class ExtractWordsJob < ApplicationJob
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  def perform(page)
    page = Page.find page unless page.is_a?(Page)
    page.download_page_file unless page.cached_page_file

    page_text = page.extract_page_text

    word_values = page_text.split(/[^a-zA-Z0-9]+/).compact
    extracted_words = word_values.map do |word_value|
      word_value.downcase
    rescue StandardError => e
      Rails.logger.info "Could not downcase #{word_value}: #{e.message}"
      word_value
    end

    extracted_words.reject!(&:blank?)

    $redis_words.pipelined do
      extracted_words.each_with_index do |word_value, index|
        appearance = {}

        appearance[:word_count] ||= 0
        appearance[:word_count] += 1

        appearance[:total_words_on_page] ||= extracted_words.count

        appearance[:next_values] ||= []
        appearance[:next_values] << extracted_words[index + 1]
        appearance[:next_values].compact!&.uniq!

        appearance[:prev_values] ||= []
        appearance[:prev_values] << extracted_words[index - 1]
        appearance[:prev_values].compact!&.uniq!

        appearance[:first_index] ||= index

        appearance[:all_indexes] ||= []
        appearance[:all_indexes] << index

        word = Word.new(word_value)
        word.set_page(page.url, appearance)
      end
    end

  end

end
