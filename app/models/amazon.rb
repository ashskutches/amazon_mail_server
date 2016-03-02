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
    @raw_orders ||= get_order_data_from_amazon(days: 30)
  end

  def get_order_data_from_amazon(days: 5)
    time_ago = (Time.now - days.day).iso8601
    response = client.list_orders(created_after: time_ago)
    return (response.parse['Orders']['Order'] rescue [])
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
