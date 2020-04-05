# frozen_string_literal: true

class Page < ApplicationRecord
  class FetchInvalidError < StandardError; end
  class FetchFailureError < StandardError; end

  has_one_attached :page_file

  validates :url, presence: true

  def download
    mechanize_page = self.class.get(url)
    raise FetchFailureError, 'Page is nil' if mechanize_page.nil?
    raise FetchInvalidError, 'Only html pages are supported' unless mechanize_page.is_a?(Mechanize::Page)

    io = StringIO.new mechanize_page.body
    page_file.attach io: io, filename: url
  end

  def self.get(url)
    mechanize_agent.get(url)
  end

  def self.mechanize_agent
    return @agent unless @agent.nil?

    @agent ||= Mechanize.new
    @agent.history.max_size = 5 # default is 50
    @agent.robots = true
    @agent
  end
end
