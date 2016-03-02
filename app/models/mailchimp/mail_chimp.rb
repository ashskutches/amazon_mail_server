class MailChimp

  def initialize
    set_client
  end

  def lists
    @lists ||= (client.lists.retrieve['lists'] rescue [])
  end

  def client
    @client
  end

  def set_client
    Gibbon::Request.api_key = config['key']
    Gibbon::Request.timeout = 15
    @client ||= Gibbon::Request.new
  end

  def config
    APP_CONFIG['mailchimp']
  end
end
