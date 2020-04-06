json.extract! page, :id, :url, :created_at, :updated_at
json.resource_url page_url(page, format: :json)

json.page_file_url url_for(page.page_file) if page.page_file.attached?

