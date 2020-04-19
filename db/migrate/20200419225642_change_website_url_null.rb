class ChangeWebsiteUrlNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :pages, :website, false
  end
end
