ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'daily_reports' do |m2|
    # Batch view for all users: reports of all users in one day
    m2.with_options :action => 'all_users' do |m3|
      m3.connect 'daily_reports/all_users'
      m3.connect 'daily_reports/all_users/:date'
    end

    # Batch view for one user: reports within one month of one user
    m2.with_options :action => 'one_user' do |m3|
      m3.connect 'daily_reports/one_user/:user_id'
      m3.connect 'daily_reports/one_user/:user_id/:date'
    end

    m2.connect 'daily_reports/new/:date', :action => 'new'
  end

  map.resources :daily_reports
end
