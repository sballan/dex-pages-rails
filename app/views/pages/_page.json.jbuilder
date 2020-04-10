json.extract! page, :id, :url, :created_at, :updated_at
json.resource_url page_url(page, format: :json)
