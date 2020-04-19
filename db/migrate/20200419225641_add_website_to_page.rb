class AddWebsiteToPage < ActiveRecord::Migration[6.0]
  def change
    add_reference :pages, :website, null: true, foreign_key: true
  end
end
