class AmazonController < ApplicationController
  before_action :set_amazons

  def sync
    @mailchimp.delete_amazon_users_off_mailchimp
    if @amazon.sync
      sleep 10
      @mailchimp.add_new_amazon_customers_to_mailchimp
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
