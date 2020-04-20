class AddDownloadMetricsToPage < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :download_success, :datetime
    add_column :pages, :download_failure, :datetime
    add_column :pages, :download_invalid, :datetime
  end
end
