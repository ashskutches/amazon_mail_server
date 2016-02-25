json.array!(@orders) do |order|
  json.extract! order, :id, :customer_id, :notes
  json.url order_url(order, format: :json)
end
