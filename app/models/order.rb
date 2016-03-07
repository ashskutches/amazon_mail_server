class Order < ActiveRecord::Base
  validates :uid, uniqueness: true

  belongs_to :customer

  def self.create_from_amazon_data(_customer, order_data)
    Order.create(
      customer_id: _customer.id,
      notes: order_data.to_s,
      source: "amazon",
      amount: (order_data['OrderTotal']['Amount'].to_f rescue 0.00),
      status: order_data['OrderStatus'],
      uid: order_data['AmazonOrderId'],
      date_created_on_amazon: order_data['PurchaseDate'].to_datetime,
      title: order_data['Title'],
      asin: order_data['ASIN']
    )
  end
end
