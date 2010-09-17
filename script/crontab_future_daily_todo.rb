today = Date.today
unfinished_entries = DailyTodoEntry.all(:conditions => {:begin => '00:00', :end => '00:00'})

# Only slide past entries, not future entries
unfinished_entries.each do |entry|
  id = entry.daily_todo_id
  todo = DailyTodo.find(id)

  if todo.date < today
    today_todo = DailyTodo.first(:conditions => {:user_id => todo.user_id , :date => today})
    today_todo = DailyTodo.new(:user_id => todo.user_id, :date => date) if today_todo.nil?
    
    entry.update_attributes(:daily_todo_id => today_todo.id)
  end
end
