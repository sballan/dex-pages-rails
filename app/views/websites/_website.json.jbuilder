json.extract! website, :id, :url, :created_at, :updated_at
json.resource_url website_url(website, format: :json)