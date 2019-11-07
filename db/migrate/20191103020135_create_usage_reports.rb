class CreateUsageReports < ActiveRecord::Migration[6.0]
  def change
    create_table :usage_reports do |t|
      t.integer :promotion_id
      t.integer :invocations_count, default: 0
      t.float :negative_responses_count, default: 0
      t.float :average_response_time, default: 0
      t.float :total_money_spent, default: 0

      t.timestamps
    end
  end
end
