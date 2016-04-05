require_relative 'csv'

class Report
  attr_accessor :raw_report, :type

  TYPES = {
    listing: "_GET_MERCHANT_LISTINGS_DATA_",
    errors: "_GET_MERCHANT_LISTINGS_DEFECT_DATA_",
    tab_listing: "_GET_MERCHANT_LISTINGS_DATA_BACK_COMPAT_"
  }

  def initialize params = {}
    @type_name = params[:type] || 'listing'
    self.type = Report::TYPES[@type_name.to_sym]
    handle_errors
    generate_report_on_amazon
    retrieve_report_from_amazon
  end

  def csv
    @csv ||= self.raw_report.parse
  end

  private

  def report_id
    report_list_response = Nokogiri::XML(client.get_report_list.body).remove_namespaces!
    report_id = nil
    report_info = report_list_response.xpath('//ReportInfo').each do |thing|
      if thing.to_s.include? self.type
        report_id = thing.at_xpath('//ReportId').content
      end
    end
    return report_id
  end

  def retrieve_report_from_amazon
    while report_id.nil?
      puts "REPORT ID NIL"
      sleep 10
    end
    self.raw_report = client.get_report(report_id)
  end

  def generate_report_on_amazon
    one_day_ago = Time.parse("2016-1-14").iso8601
    now = Time.now.iso8601
    client.request_report(self.type,
      {
        start_date: one_day_ago,
        end_date: now
      }
    )
  end

  def client
    client ||= MWS::Reports::Client.new(
      primary_marketplace_id: config['MWS_MARKETPLACE_ID'],
      merchant_id: config['MWS_MERCHANT_ID'],
      aws_access_key_id: config['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: config['AWS_SECRET_ACCESS_KEY']
    )
  end

  def config
    APP_CONFIG['amazon']
  end

  def handle_errors
    MWS::Reports::Client.on_error do |e|
      puts "Error log empty" if e.nil?
      puts(e.cause) if e.cause
      raise "Closed connection with Amazon"
    end
  end
end
