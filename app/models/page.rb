# frozen_string_literal: true

class Page < ApplicationRecord
  class FetchInvalidError < StandardError; end
  class FetchFailureError < StandardError; end

  scope :only_with_page_file, -> { self.joins(:page_file_attachment) }

  has_one_attached :page_file
  validates :url, presence: true
  serialize :links, JSON

  def extract_page_text
    return nil unless cached_page_file

    doc = Nokogiri::HTML(cached_page_file)
    doc.xpath('//script').remove
    doc.xpath('//style').remove

    Html2Text.convert doc.to_html.force_encoding('UTF-8')
  end

  def extract_page_links
    return nil unless cached_page_file

    doc = Nokogiri::HTML(cached_page_file)
    anchor_elems = doc.css('a')
    link_strings = anchor_elems.map { |link| link['href'] }.compact.uniq
    link_strings.select! do |link|
      link.starts_with?('http', 'https', 'www') ? true : false
    end

    self.links = link_strings
    save

    self.links
  end

  def cached_page_file
    return nil unless page_file.attached?

    @cached_page_file ||= page_file.download
  end

  def download_page_file
    raise FetchFailureError, 'Page is nil' if mechanize_page.nil?
    raise FetchInvalidError, 'Only html pages are supported' unless mechanize_page.is_a?(Mechanize::Page)

    io = StringIO.new mechanize_page.body.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    page_file.attach io: io, filename: url
  end

  def mechanize_page
    @mechanize_page ||= self.class.mechanize_agent.get(url)
  rescue Mechanize::RobotsDisallowedError => e
    Rails.logger.error e
    raise FetchInvalidError, 'Robots not allowed for this page'
  end

  def self.mechanize_agent
    return @mechanize_agent unless @mechanize_agent.nil?

    @mechanize_agent ||= Mechanize.new
    @mechanize_agent.history.max_size = 5 # default is 50
    @mechanize_agent.robots = true
    @mechanize_agent
  end
end
