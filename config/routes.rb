ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'daily_todos' do |m2|
    # Batch view for all users: todos of all users in one day
    m2.with_options :action => 'all_users' do |m3|
      m3.connect 'daily_todos/all_users'
      m3.connect 'daily_todos/all_users/:date'
    end

    # Batch view for one user: todos within one month of one user
    m2.with_options :action => 'one_user' do |m3|
      m3.connect 'daily_todos/one_user/:user_id'
      m3.connect 'daily_todos/one_user/:user_id/:date'

    end
    m2.connect 'daily_todos/new/:date', :action => 'new'
  end
  
  map.resources :daily_todos
  map.resources :daily_todo_entries
  map.resources :daily_todo_comments
  map.todo_comment_new 'daily_todos/:daily_todo_id/comments/new', :controller => 'daily_todo_comments', :action => 'new' 
  map.todo_comment_edit 'daily_todos/:daily_todo_id/comments/:id/edit', :controller => 'daily_todo_comments', :action => 'edit'
  map.todo_entry_new 'daily_todos/:daily_todo_id/entries/new', :controller => 'daily_todo_entries', :action => 'new'
  map.todo_entry_edit 'daily_todos/:daily_todo_id/entries/:id/edit', :controller => 'daily_todo_entries', :action => 'edit'
  map.connect 'daily_todos/:date/new', :controller => 'daily_todos', :action => 'create_todo'
end
