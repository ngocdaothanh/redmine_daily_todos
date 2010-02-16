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
end
