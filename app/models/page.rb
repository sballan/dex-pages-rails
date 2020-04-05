# frozen_string_literal: true

class Page < ApplicationRecord
  has_one_attached :page_download

  validates :url, presence: true

  # def fetch_page
  #   mechanize_page = Index.fetch_page(url_string)
  #   raise FetchFailureError, 'Page is nil' if mechanize_page.nil?
  #   raise FetchInvalidError, 'Only html pages are supported' unless mechanize_page.is_a?(Mechanize::Page)

  #   download_content = mechanize_page.body.encode('ASCII-8BIT', invalid: :replace, undef: :replace, replace: '')
  #   raise FetchInvalidError, 'Page is blank' if download_content.blank?

  #   download = downloads.create!(content: download_content)

  #   with_lock do
  #     update_links!(download.links)
  #     update_title!(download.title)
  #   end

  #   self[:download_success] = Time.now.utc
  #   save!
  # rescue Mechanize::ResponseCodeError => e
  #   # raise e unless %w[500 410 409 404 403 400].include?(e.response_code)

  #   self[:download_invalid] = Time.now.utc
  #   save!
  # rescue FetchInvalidError, Mechanize::RobotsDisallowedError, Mechanize::RedirectLimitReachedError
  #   self[:download_invalid] = Time.now.utc
  #   save!
  # rescue StandardError
  #   self[:download_failure] = Time.now.utc
  #   save!

  #   raise
  # end
end
