class AmazonMailChimp < MailChimp
  def add_new_amazon_customers_to_mailchimp
    amazon_customers = Customer.joins(:orders).where(orders: { source: 'amazon', follow_up_email_sent: false, date_created_on_amazon: BusinessDayCalculator.business_days_ago(7)} ).distinct
    amazon_customers.each do |customer|
      subscribe_amazon_user(customer)
    end
  end

  def subscribe_amazon_user(customer)
    begin
      customer.orders.update_all(follow_up_email_sent: true)
      name = customer.name.scan(/^(\w+)[ .,](.+$)/).flatten
      client.lists(amazon_list['id']).members.create(
        body: {
        email_address: customer.email,
        status: "subscribed",
        merge_fields: {FNAME: name.first, LNAME: name.last}
      })
    rescue Gibbon::MailChimpError=>e
      puts e
    end

  end

  def amazon_members
    client.lists(amazon_list['id']).members.retrieve(params: {"count": "500"})['members']
  end

  def amazon_list
    lists.select { |l| l['name'] = "amazon" }.first
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
