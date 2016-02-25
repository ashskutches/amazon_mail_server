class Amazon
  def initialize
    handle_errors
  end

  def sync
    Customer.destroy_all
    Order.destroy_all
    orders.each do |order|
      customer = Customer.create(name: order['BuyerName'], email: order['BuyerEmail'])
      order = Order.create(customer_id: customer.id, notes: order.to_s)
    end
  end

  def orders
    @orders ||= (get_orders.parse['Orders']['Order'] rescue [])
  end

  private

  def get_orders
    yesterday = (Time.now - 6.day).iso8601
    client.list_orders(created_after: yesterday)
  end

  def handle_errors
    MWS::Orders::Client.on_error do |e|
      if e.response.status == 503
        logger.warn e.response.message
      end
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
