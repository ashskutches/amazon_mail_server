class AddUidToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :uid, :string
  end
end
