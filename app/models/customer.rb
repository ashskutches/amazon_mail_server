class Customer < ActiveRecord::Base
  validates :email, uniqueness: true

  has_many :orders

  def self.create_from_amazon_data(order_data)
    customer = Customer.find_or_create_by(email: order_data['BuyerEmail'])
    customer.update(name: order_data['BuyerName'])
    return customer.reload
  end
end
