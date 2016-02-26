class AmazonController < ApplicationController

  def sync
    amazon = Amazon.new
    if amazon.sync
      redirect_to '/customers', notice: 'Sync was successful!'
    else
      render :new, failure: "Something went wrong"
    end
  end
end
