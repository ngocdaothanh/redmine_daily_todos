date = Date.today
time = Time.now
@entry_begin_is_empty = DailyTodoEntry.all(:conditions => {:begin => '00:00',:end => '00:00'})
@allusers =  @entry_begin_is_empty.each do |entry|
                  entry.daily_todo.user_id
             end
if @allusers != nil
  @allusers.each do |user|
     reported = (DailyTodo.first(:conditions => {:user_id => user.daily_todo.user_id , :date => date }) == nil)
     if reported
       todo = DailyTodo.new(:date => date, :lunch => time, :user_id => user.daily_todo.user_id )
       todo.save
     end
   end
   todos = DailyTodo.all
   todos.each do |daily_id|
      DailyTodoEntry.find(:all, :conditions => {:daily_todo_id => daily_id.id, :begin => '00:00'}).each do |obj|
        obj.update_attributes(:daily_todo_id => DailyTodo.first( :conditions => {:user_id => daily_id.user_id, :date => date }).id)
      end
   end
end
