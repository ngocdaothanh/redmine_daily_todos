Command line:
- crontab -e:  edit crontab
- crontab -l: view crontab
- Copy this into crontab file: 10 0 * * * /usr/local/bin/ruby /root/redmine-1.0.1/script/runner /root/redmine-1.0.1/vendor/plugins/redmine_daily_todos/app/crontab_future_daily_todo.rb
Note:
- /usr/local/bin/ruby: duong dan cai dat ruby co the xem bang lenh "which ruby"
- /root/redmine-1.0.1/script/runner: {release path/script/runner}
- root/redmine-1.0.1/vendor/plugins/redmine_daily_todos/app/crontab_future_daily_todo.rb: {release path/crontab_future_daily_todo.rb}

