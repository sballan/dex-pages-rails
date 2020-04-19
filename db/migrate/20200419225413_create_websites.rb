class CreateWebsites < ActiveRecord::Migration[6.0]
  def change
    create_table :websites do |t|
      t.text :url

      t.timestamps
    end
    add_index :websites, :url, unique: true
  end
end
