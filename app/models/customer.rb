class Customer < ActiveRecord::Base
  validates :email, uniqueness: true
  validates_presence_of :email

  has_many :orders

  def self.create_from_amazon_data(order_data)
    customer = Customer.find_or_create_by(email: order_data['BuyerEmail'])
    if customer.errors.count == 0
      customer.update(name: order_data['BuyerName'])
      customer.reload
    else
      return nil
    end
  end
end
