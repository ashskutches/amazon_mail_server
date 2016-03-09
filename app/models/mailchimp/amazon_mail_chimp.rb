class AmazonMailChimp < MailChimp
  def add_new_amazon_customers_to_mailchimp
    business_day = BusinessDayCalculator.business_days_ago(7)
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
    rescue Gibbon::MailChimpError=>e
      puts e
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
