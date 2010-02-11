require 'redmine'

Redmine::Plugin.register :redmine_daily_reports do
  name 'Daily Reports'
  author 'GNT'
  description 'A plugin for managing daily reports'
  version '0.0.1'

  menu :top_menu, :daily_reports, {:controller => 'daily_reports', :action => 'all_users'}, :caption => 'Daily Reports'
end
