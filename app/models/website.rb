class Website < ApplicationRecord
  has_many :pages

  scope :should_scrape, -> {
    self.where(
      should_scrape: true
    )
  }

  scope :scrape_unlocked, -> {
    self.where(
      scrape_locked_at: nil
    ).or(
    self.where(
      scrape_locked_at: (99.years.ago..Time.now)
    ))
  }

  def pages_to_scrape
    pages.sort_by {|p| p.download_success || 0 }
  end

  def scrape_lock!(locked_by)
    raise 'Cannot aquire lock!' if scrape_locked?

    self.scrape_locked_at = Time.now
    self.scrape_locked_by = locked_by
    save!
  end

  def scrape_locked?
    return false if scrape_locked_at.nil?
    return true if (Time.now - scrape_locked_at) < SCRAPE_LOCK_TIME

    self.scrape_locked_at = nil
    self.scrape_locked_by = nil
    save # returns false if save fails
  end
end
