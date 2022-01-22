json.extract! silver_product, :id, :title, :pieces, :in_stock, :total_price, :price_per_oz, :created_at, :updated_at, :date_parsed
json.url silver_product_url(silver_product, format: :json)
