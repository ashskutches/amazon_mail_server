class AmazonMailChimp < MailChimp
    def add_new_amazon_customers_to_mailchimp
      amazon_customers = Customer.joins(:orders).where(orders: { source: 'amazon'} ).distinct
      amazon_customers.each do |customer|
        subscribe_amazon_user(customer)
      end
  end

  def subscribe_amazon_user(customer)
    begin
      #if customer.name.nil? || customer.email.nil?
      name = customer.name.scan(/^(\w+)[ .,](.+$)/).flatten
      puts "Creating"
      puts "===="
      puts name
      puts "===="
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

  def unsubscribe_amazon_users
    begin
      100.times { puts "\n" }
      puts "===="
      puts "Existing Amazon list needs to be unsubscribed."
      puts "===="
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
