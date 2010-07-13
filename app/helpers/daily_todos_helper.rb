module DailyTodosHelper
  def format_date_with_weekday(date)
    return nil unless date
    Setting.date_format.blank? ? ::I18n.l(date.to_date, :count => date.day, :format => "%A %d-%m-%y") : date.strftime(Setting.date_format)
  end
end
