class DailyTodoComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :daily_todo
end
