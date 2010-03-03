class DailyTodosSchema < ActiveRecord::Migration
  def self.up
    create_table :daily_todos do |t|
      t.integer :user_id
      t.date    :date
      t.time    :lunch
    end
    
   create_table :daily_todo_entries do |t|
    t.integer  :daily_todo_id
    t.text     :plan
    t.time     :begin
    t.time     :end
    t.text     :result
   end
   
   create_table :daily_todo_comments do |t|
    t.integer   :daily_todo_id
    t.integer   :user_id
    t.text      :body
    t.timestamp :created_at
    t.timestamp :updated_at
   end
  end
  
  def self.down
    drop_table :daily_todos
    drop_table :daily_todo_entries
    drop_table :daily_todo_comments
  end
end
