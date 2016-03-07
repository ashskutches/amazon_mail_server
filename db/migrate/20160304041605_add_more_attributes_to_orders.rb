class AddMoreAttributesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :title, :string
    add_column :orders, :asin, :string
  end
end
