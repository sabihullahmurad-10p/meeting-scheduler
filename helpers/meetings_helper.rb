module MeetingsHelper
  def invalid_meetings?(meetings)
    # have not used blank? or empty? as it is not present in core ruby
    # for that have to add activesupport gem
    meetings.any? { |m| m[:duration].nil? || m[:duration] == '' || m[:type].nil? || m[:type] == '' }
  end
end
