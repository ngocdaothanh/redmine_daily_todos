class DailyReportsSchema < ActiveRecord::Migration
  def self.up
    create_table :daily_reports do |t|
      t.integer :user_id
      t.date    :date
      t.text    :plan
      t.time    :lunch_begin
      t.time    :lunch_end
      t.text    :reality
      t.text    :next_plan
    end
  end
  
  def self.down
    drop_table :daily_reports
  end
end
