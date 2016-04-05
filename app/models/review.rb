class Review < ActiveRecord::Base
  def self.create_from_html(account_id, html)
    Review.find_or_create_by(
      amazon_account_id: account_id,
      rating: star_rating(html),
      author_name: html.css('.author').text,
      date_created_on_amazon: html.css('.review-date').text.to_date,
      content: html.css('.review-text').text,
      order_id: nil
    )
  end

  def self.star_rating(html)
    return 5 if html.css('.a-star-5').any?
    return 4 if html.css('.a-star-4').any?
    return 3 if html.css('.a-star-3').any?
    return 2 if html.css('.a-star-2').any?
    return 1 if html.css('.a-star-1').any?
  end
end