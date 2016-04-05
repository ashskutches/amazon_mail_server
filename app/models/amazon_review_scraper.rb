require 'nokogiri'
require 'open-uri'

class AmazonReviewScraper
  def report
    @report ||= Report.new
  end

  def collect_product_asins
    raise "NO REPORT" if report.csv.nil?

    report.csv.by_row.collect do |row|
      row['asin1']
    end.flatten
  end

  def product_asins
    @product_asins ||= collect_product_asins
  end

  def product_url(asin)
    "http://www.amazon.com/dp/#{asin}"
  end

  def create_all_the_reviews
    product_asins.each do |asin|
      binding.pry
      doc = Nokogiri::HTML(open(product_url(asin)))
      binding.pry
    end
  end
end
