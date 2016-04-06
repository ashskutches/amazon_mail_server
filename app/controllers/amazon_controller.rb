class AmazonController < ApplicationController
  before_action :set_amazons

  def sync
    puts "Delete Amazon users"
    @mailchimp.delete_amazon_users_off_mailchimp
    puts "======="
    puts "Deletion complete"
    puts "======="
    puts "Amazon Sync....."
    if @amazon.sync
      sleep 10
      puts "======="
      puts "Adding new Amazon Customers"
      @mailchimp.add_new_amazon_customers_to_mailchimp(8)
      redirect_to '/customers', notice: 'Sync was successful!'
    else
      render :new, failure: "Something went wrong"
    end
  end

  def set_amazons
    @amazon = Amazon.new
    @mailchimp = AmazonMailChimp.new
  end
end
