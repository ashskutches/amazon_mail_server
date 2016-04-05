require 'nokogiri'
require 'open-uri'

class AmazonReviewScraper
  def initialize(_amazon_account)
    @amazon_account = _amazon_account
    @report ||= Report.new(@amazon_account)
  end

  def collect_product_asins
    raise "NO REPORT" if @report.csv.nil?

    @report.csv.by_row.collect do |row|
      row['asin1']
    end.flatten
  end

  def product_asins
    @product_asins ||= collect_product_asins
  end

  def product_url(asin)
    "http://amazon.com/product-reviews/#{asin}"
  end

  def create_all_the_reviews
    begin
      product_asins.each do |asin|
        doc = Nokogiri::HTML(open(product_url(asin)))
        review_section = doc.css("#cm_cr-review_list")
        reviews = review_section.children
        reviews.each do |html|
          Review.create_from_html(@amazon_account.id, html)
        end
        sleep(30)
      end
    rescue OpenURI::HTTPError => error
      response = error.io
      puts "ERROR"
      puts response.status
      # => ["503", "Service Unavailable"]
      puts response.string
      # => <!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n<html DIR=\"LTR\">\n<head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"initial-scale=1\">...
    end
  end

end
