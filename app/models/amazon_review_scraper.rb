require 'nokogiri'
require 'open-uri'

class AmazonReviewScraper
  def initialize
    @report ||= Report.new
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

  def get_product_page(asin)
    begin
      Nokogiri::HTML(open(product_url(asin)))
    rescue OpenURI::HTTPError => error
      puts "ERROR"
      puts error.io.status
      #puts error.io.string
      return false
    end
  end

  def create_all_the_reviews
    product_asins.each do |asin|
      product_page = get_product_page(asin)
      while product_page == false
        sleep(1.5)
        product_page = get_product_page(asin)
      end
      review_section = product_page.css("#cm_cr-review_list")
      reviews = review_section.children
      reviews.each do |html|
        Review.create_from_html(asin, html)
      end
    end
  end

end
