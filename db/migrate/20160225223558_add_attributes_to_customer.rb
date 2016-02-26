class AddAttributesToCustomer < ActiveRecord::Migration
  def change
    add_column :orders, :follow_up_email_sent, :boolean, default: false
    add_column :orders, :source, :string
    add_column :orders, :status, :string
    add_column :orders, :amount, :float
  end
end
