module DailyTodosHelper
  def format_date_with_weekday(date)
    return nil unless date
    Setting.date_format.blank? ? ::I18n.l(date.to_date, :count => date.day, :format => :weekday_and_default) : date.strftime(Setting.date_format)
  end
end
