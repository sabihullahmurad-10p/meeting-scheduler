require_relative 'application_service'
require_relative '../helpers/meetings_helper'
require_relative '../helpers/time_helper'
require_relative '../errors'

class MeetingScheduler < ApplicationService
  include MeetingsHelper
  include TimeHelper

  DEFAULT_START_TIME_HOURS = 9
  DEFAULT_MEETING_DURATION_HOURS = 8 # can also be made configurable
  attr_accessor :meetings, :meeting_start_time, :meeting_end_time, :scheduled_meetings, :default_meeting_duration

  def initialize(meetings_list)
    @meetings = meetings_list
    @meeting_start_time = time_in_hours(ENV['START_TIME']&.to_i || DEFAULT_START_TIME_HOURS)
    @scheduled_meetings = []
    @meeting_end_time = @meeting_start_time
    @default_meeting_duration = @meeting_start_time + add_hours(DEFAULT_MEETING_DURATION_HOURS)
  end

  def call
    schedule_meetings
    display_meetings
  end

  private

  def schedule_meetings
    raise Errors::InvalidMeetingException, 'Meeting List not Valid' if invalid_meetings?(@meetings)

    sorted_meetings.each_with_index do |meeting, i|
      # add half an hour for offsite meeting if there are onsite meetings before
      @meeting_start_time += add_hours(0.5) if meeting[:type] == :offsite && i > 0
      add_to_scheduler_array(meeting)
      #setting the end time of previous meeting to start time of next
      @meeting_start_time = @meeting_end_time
    end
  end

  def get_scheduled_json(meeting)
    {
      start_time: to_time_format(@meeting_start_time),
      end_time: to_time_format(@meeting_end_time),
      name: meeting[:name]
    }
  end

  def add_to_scheduler_array(meeting)
    # adding duration after convert them to pure ruby duration
    @meeting_end_time = @meeting_start_time + add_hours(meeting[:duration])
    @scheduled_meetings << get_scheduled_json(meeting)
  end

  def display_meetings
    if can_fit_into_schedule?
      puts 'Yes, can fit. One possible solution would be:'
      @scheduled_meetings.each do |meeting|
        puts "#{meeting[:start_time]} - #{meeting[:end_time]} - #{meeting[:name]}"
      end
    else
      puts 'No, can’t fit.'
    end
  end

  def can_fit_into_schedule?
    # validating that end time of last meeting hasnt surpassed
    # start_time of first meeting + default duration
    @meeting_end_time <= @default_meeting_duration
  end

  def sorted_meetings
    @meetings.partition { |meeting| meeting[:type] == :onsite }.flatten
  end
end
