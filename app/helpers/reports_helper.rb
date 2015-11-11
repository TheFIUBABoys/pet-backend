module ReportsHelper

  def average_time(seconds)
    time = seconds.round(1)
    return "#{time} #{I18n.t('shared.seconds')}" if time < 60

    time = (time / 60.0).round(1)
    return "#{time} #{I18n.t('shared.minutes')}" if time < 60

    time = (time / 60.0).round(1)
    return "#{time} #{I18n.t('shared.hours')}" if time < 24

    time = (time / 24.0).round(1)
    "#{time} #{I18n.t('shared.days')}"
  end

end
