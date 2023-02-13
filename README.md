# Meeting Scheduler

- [Project Description](#project-description)
- [Running Project](#running-project)
- [Implementation Overview](#implementation-overview)



# Project Description

Your product owner is asking you to implement a new feature in the calendar system
that is in your scheduling tool. The feature needs to support arranging a set of
meetings within an 8 hour day in a way that makes them work, and let the user know
if the meetings cannot fit into the day.

For this feature there will be two kinds of meetings, on-site meetings and off-site
meetings. On-site meetings can be scheduled back to back with no gaps in between
them, but off-site meetings must have 30 minutes of travel time padded to either
end. This travel time however can overlap for back to back off-site meetings, and can
extend past the start and end of the day.

# Running Project
- Ruby-Version: 2.7.3
- Run `bundle install`
- copy the content of `.env.sample` and create a new file as `.env` and paste the content in it.  
- `.env` may contain `START_TIME`, `OFFSITE_MEETING_GAP_HOURS` and `DEFAULT_DURATION` in it which represents the start_time of first meeting of the day, gap between offsite neetings in hours and default duration of day in hours
- Run the main file using the ruby command `ruby starter.rb`
- Run test case using `rspec spec/meeting_scheduler_spec.rb`

# Implementation Overview
`starter.rb`
- The root/main file for running the `meeting_scheduler` service.
- It contains the *meetings_list* array of json/hash which act as a sample meeting list/data to be provided to service.

`meeting_scheduler.rb`
- The service that schedules the meeting as per requirements
- It gets inherited from `application_service.rb` i.e ApplicationService class which has the implementation of *call* method.
- *call* method forwards the arguments receieved in *MeetingScheduler.call()* to *new/initialize* of calling class and invokes *call* method.
- The service logic starts with the partition of meeting list based on their types.
- It adds the duration provided to meeting time and adds additonal 0.5 hours incase offsite meetings.
- It displays the message if the meetings can fit in during the specified day time followed by meetings or else displays `No, can’t fit.`.

`meeting_scheduler_spec.rb`
- contains the test cases for `meeting_scheduler.rb` or `MeetingScheduler` class.

`errors.rb`
- The code has new class called `InvalidMeetingException` that inherits from the standard `StandardError` class in Ruby.
- It is being used to display error or exception messages incase of invalid meeting list provided by `starter.rb`
