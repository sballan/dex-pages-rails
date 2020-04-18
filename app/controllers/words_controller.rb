class WordsController < ApplicationController
  before_action :set_word, only: %i[
    show
  ]

  def index
    if params[:count]
      count = params[:count].to_i
    end
    @words = Word.all(count: count)
  end

  def show
    @word = Word.find(params[:id])
  end

  def query
    word = Word.find(params[:id])
    @result = word.to_h.map do |url, appearance|
      {
        url: url,
        appearance: appearance
      }
    end

    @result.sort_by! do |hit|
      # ...TODO: do this part.
      appearance = hit[:appearance]
      order_rating = appearance['first_index']
      freq_rating = appearance['total_words_on_page'].to_f / appearance['word_count']
      order_rating * freq_rating
    end
  end
end
