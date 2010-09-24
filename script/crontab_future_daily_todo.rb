today = Date.today
time = Time.now

unfinished_entries = DailyTodoEntry.all(:conditions => {:begin => '00:00', :end => '00:00'})

# Only slide past entries, not future entries
unfinished_entries.each do |entry|
  id = entry.daily_todo_id
  todo = DailyTodo.find(id)

  if todo.date < today
    today_todo = DailyTodo.first(:conditions => {:user_id => todo.user_id , :date => today})
    today_todo = DailyTodo.create(:user_id => todo.user_id, :date => today, :lunch => time) if today_todo.nil?
    
    entry.update_attributes(:daily_todo_id => today_todo.id)
  end
end

DailyTodo.destroy_all("id not in (select distinct daily_todo_id from daily_todo_entries)
  and id not in (select distinct daily_todo_id from daily_todo_comments)"
)
