require 'redmine'

Redmine::Plugin.register :redmine_daily_todos do
  name 'Daily TODOs'
  author 'GNT'
  description 'A plugin for managing daily TODOs'
  version '0.0.1'

  menu :top_menu, :daily_todos,
    {:controller => 'daily_todos', :action => 'all_users'}, :caption => 'Daily TODOs'
end
