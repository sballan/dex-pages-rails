class AddLockToWebsite < ActiveRecord::Migration[6.0]
  def change
    add_column :websites, :scrape_locked_at, :datetime
    add_column :websites, :scrape_locked_by, :string

    add_index :websites, :scrape_locked_at
    add_index :websites, :scrape_locked_by
  end
end
