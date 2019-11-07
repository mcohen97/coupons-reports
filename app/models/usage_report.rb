class UsageReport < ApplicationRecord
  
  after_initialize :default_values

  validates :promotion_id, uniqueness: true, presence: true
  validates :invocations_count, numericality: { greater_than_or_equal_to: 0 }
  validates :negative_responses_count, numericality: { greater_than_or_equal_to: 0 }
  validates :negative_responses_count, numericality: { less_than_or_equal_to: ->(report) { report.invocations_count }}
  validates :average_response_time, numericality: { greater_than_or_equal_to: 0 }
  validates :total_money_spent, numericality: { greater_than_or_equal_to: 0 }


private

  def default_values
    self.invocations_count = 0 if self.invocations_count.nil?
    self.negative_responses_count = 0 if self.negative_responses_count.nil?
    self.negative_responses_count = 0 if self.negative_responses_count.nil?
    self.average_response_time = 0 if self.average_response_time.nil?
    self.total_money_spent = 0 if self.total_money_spent.nil?
  end

end
