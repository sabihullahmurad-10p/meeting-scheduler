# Meeting Scheduler

- [Project Description](#project-description)
- [Running Project](#running-project)


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
- Run `bundle install`
- copy the content of `.env.sample` and create a new file as `.env` and paste the content in it.  
- `.env` may contain `START_TIME` in it which represents the start_time of first meeting of the day
- Run the main file using the ruby command `ruby starter.rb`
