class BusinessDayCalculator

  def self.business_days_ago(how_many_business_days_ago)
    days_traveled = 0
    date = Date.today

    while days_traveled != how_many_business_days_ago
      date = date - 1.day
      days_traveled = days_traveled + 1 unless date.saturday? or date.sunday?
    end
    return date
  end

  def self.regular_days_ago(how_many_business_days_ago)
    date = Date.today - how_many_business_days_ago
  end

end
