class AddDateOrderCreatedOnAmazon < ActiveRecord::Migration
  def change
    add_column :orders, :date_created_on_amazon, :date
  end
end
