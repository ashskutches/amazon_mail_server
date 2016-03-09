class Amazon
  def initialize
    handle_errors
  end

  def sync
    raw_orders.each do |raw_order|
      customer = Customer.create_from_amazon_data(raw_order)
      if customer
        order = Order.create_from_amazon_data(customer, raw_order)
      end
    end
  end

  private

  def raw_orders
    date = Date.today - 8
    @raw_orders ||= get_order_data_from_amazon(date)
  end

  def get_order_data_from_amazon(date)
    puts "Getting Order Data"
    time_ago = date.iso8601
    puts "Get Orders"
    response = client.list_orders(created_after: time_ago)
    orders = (response.parse['Orders']['Order'] rescue [])
    orders.each do |order|
      puts "Get Order Details"
      sleep 1
      product_response = client.list_order_items(order['AmazonOrderId']).parse
      order["Title"] = (product_response['OrderItems']['OrderItem']["Title"] rescue nil)
      order["ASIN"] = (product_response['OrderItems']['OrderItem']["ASIN"] rescue nil)
    end
    return orders
  end

  def handle_errors
    MWS::Orders::Client.on_error do |e|
      puts "---Amazon---ERROR---"
      puts e
      puts e.try(:reponse.message)
    end
  end

  def client
    client ||= MWS::Orders::Client.new(
      primary_marketplace_id: config['MWS_MARKETPLACE_ID'],
      merchant_id: config['MWS_MERCHANT_ID'],
      aws_access_key_id: config['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: config['AWS_SECRET_ACCESS_KEY']
    )
  end

  def config
    APP_CONFIG['amazon']
  end
end
