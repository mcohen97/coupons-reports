class UsageReportDto
  attr_reader :invocations_count, :negative_response_ratio, :positive_response_ratio, :average_response_time, :last_time_updated, :total_money_spent

  def initialize(data)
    @invocations_count = data[:invocations_count]
    @negative_response_ratio = data[:negative_response_ratio]
    @positive_response_ratio = data[:positive_response_ratio]
    @average_response_time = data[:average_response_time]
    @total_money_spent = data[:total_money_spent]
    @last_time_updated = data[:last_time_updated]
  end

end