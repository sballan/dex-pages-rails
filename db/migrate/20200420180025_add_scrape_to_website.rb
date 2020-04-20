class AddScrapeToWebsite < ActiveRecord::Migration[6.0]
  def change
    add_column :websites, :scrape, :boolean, default: false
  end
end
