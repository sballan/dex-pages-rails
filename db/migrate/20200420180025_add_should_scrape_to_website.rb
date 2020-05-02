class AddShouldScrapeToWebsite < ActiveRecord::Migration[6.0]
  def change
    add_column :websites, :should_scrape, :boolean, default: false
  end
end
