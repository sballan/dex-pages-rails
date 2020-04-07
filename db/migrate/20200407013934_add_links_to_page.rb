class AddLinksToPage < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :links, :text, default: '[]'
  end
end
