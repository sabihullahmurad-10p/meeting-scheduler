require 'byebug'

module TimeHelper
  def to_time_format(time)
    time.strftime("%I:%M")
  end

  def time_in_hours(start_hour_time)
    time = Time.now
    start_of_day = Time.new(time.year, time.month, time.day)
    start_of_day + add_hours(start_hour_time)
  end

  def add_hours(hours)
    # as it is a ruby project so cant directly use 9.hours
    # so have to convert it before adding to start time
    hours * 60 * 60
  end
end
