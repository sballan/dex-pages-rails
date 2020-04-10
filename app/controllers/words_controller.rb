class WordsController < ApplicationController
  before_action :set_word, only: %i[
    show
  ]

  def index
    @words = Word.all
  end

  def show
    set_word
  end

  private

    def set_word
      @word = Word.find(params[:id])
    end
end
