class DailyReport < ActiveRecord::Base
  LUNCH = 1*60*60  # 1 hour for lunch

  belongs_to :user
end
