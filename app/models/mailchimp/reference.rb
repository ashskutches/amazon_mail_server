#class
  #gibbon.lists.retrieve(headers: {"SomeHeader": "SomeHeaderValue"}, params: {"query_param": "query_param_value"})
  #def daily_amazon
    #begin
      #create_amazon_list
    #rescue Gibbon::MailChimpError=>e
      #puts "Erroneous input!"
      #puts e
      #binding.pry
    #end
  #end

#
  #def create_amazon_list
#gibbon.lists(list_id).members.create(
#body: {email_address: "foo@bar.com", status: "subscribed", merge_fields: {FNAME: "First Name", LNAME: "Last Name"}})
    #client.lists.create(
      #body: {
        #name: "amazon",
        #contact: {
          #company: "MailChimp",
          #address1: "675 Ponce De Leon Ave NE",
          #address2: "Suite 5000",
          #city: "Atlanta",
          #state: "GA",
          #zip: "30308",
          #country: "US",
          #phone: ""
        #},
        #permission_reminder: "You're recieving this email because you purchased from Amazon",
        #campaign_defaults: {
          #from_name: "thecollegiatestandard",
          #from_email: "info@thecollegiatestandard.com",
          #subject: "Review",
          #language: "en"
        #},
        #email_type_option: true
      #})
  #end




  #REFERENCE

  #g.lists(list_id).members.create(
    #body: {email_address: user_email_address, status: "subscribed", interests: {some_interest_id: true, another_interest_id: true}
  #})
  #gibbon.lists(list_id).members(member_id).update(
    #body: {interests: {some_interest_id: true, another_interest_id: false}
  #})
  #gibbon.lists.retrieve(headers: {"SomeHeader": "SomeHeaderValue"}, params: {"query_param": "query_param_value"})

#end
