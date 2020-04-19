class ChangeWebsiteUrlNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :pages, :website_id, false
  end
end
