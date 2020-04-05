class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.text :url

      t.timestamps
    end
    add_index :pages, :url, unique: true
  end
end