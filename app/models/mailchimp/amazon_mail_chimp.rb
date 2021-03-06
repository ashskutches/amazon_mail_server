class AmazonMailChimp < MailChimp
  def add_new_amazon_customers_to_mailchimp(days_ago = 7)
    business_day = BusinessDayCalculator.business_days_ago(days_ago)
    if business_day.monday?
      day_range = [(business_day - 2), business_day]
    else
      day_range = business_day
    end
    amazon_customers = Customer.joins(:orders).where(orders: { source: 'amazon', follow_up_email_sent: false, date_created_on_amazon: day_range} ).distinct
    amazon_customers.each do |customer|
      subscribe_amazon_user(customer)
    end
  end

  def subscribe_amazon_user(customer)
    begin
      puts "Subscribing - #{customer.name}"
      name = customer.name.scan(/^(\w+)[ .,](.+$)/).flatten
      name = [customer.name, " "] if name.empty?
      order = customer.orders.first
      client.lists(amazon_list['id']).members.create(
        body: {
        email_address: customer.email,
        status: "subscribed",
        merge_fields: {FNAME: name.first, LNAME: name.last, ASIN: order.asin, ORDER_ID: order.uid, TITLE: order.title}
      })
      customer.orders.update_all(follow_up_email_sent: true)
      puts "*subscribed*"
    rescue Gibbon::MailChimpError=>e
      puts "Subscription ERROR: "
      puts "========="
      puts e.body['errors']
      puts "========="
    end
  end

  def amazon_members
    client.lists(amazon_list['id']).members.retrieve(params: {"count": "500"})['members']
  end

  def amazon_list
    lists.select { |l| l['name'] == "amazon" }.first
  end

  def delete_amazon_users_off_mailchimp
    begin
      amazon_members.each do |member|
        puts "Deleting member: #{member['id']}"
        client.lists(amazon_list['id']).members(member['id']).delete
      end
    rescue Gibbon::MailChimpError=>e
      puts e
    end
    #subscribed_members = amazon_members.select { |member| member['status'] == 'subscribed' }
    #if subscribed_members.count > 0
    #client.lists(amazon_list['id']).members(member['email_address']).update(body: { status: "unsubscribed" })
  end

end
