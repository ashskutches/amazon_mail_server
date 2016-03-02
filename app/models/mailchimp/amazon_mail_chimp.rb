class AmazonMailChimp < MailChimp
  def subscribe_all_amazon_users
    amazon = Amazon.new
    amazon.sync


    amazon_customers = Customer.joins(:orders).where(orders: { source: 'amazon'} ).distinct
    amazon_customers.each do |customer|
      subscribe_amazon_user(customer)
    end
  end

  def subscribe_amazon_user(customer)
    name = customer.name.scan(/^(\w+)[ .,](.+$)/).flatten
    client.lists(amazon_list['id']).members.create(
      body: {
      email_address: customer.email,
      status: "subscribed",
      merge_fields: {FNAME: name.first, LNAME: name.last}
    })
  end

  def amazon_members
    client.lists(amazon_list['id']).members.retrieve['members']
  end

  def amazon_list
    lists.select { |l| l['name'] = "amazon" }.first
  end

  def delete_amazon_users
    amazon_members.each do |member|
      client.lists(amazon_list['id']).members(member['id']).delete
    end
  end

end
