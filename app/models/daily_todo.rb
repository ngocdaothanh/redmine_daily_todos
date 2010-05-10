class DailyTodo < ActiveRecord::Base
  LUNCH = 1*60*60  # 1 hour for lunch

  belongs_to :user
  has_many :daily_todo_entries,  :order => 'begin', :dependent => :destroy
  has_many :daily_todo_comments, :dependent => :destroy
end
