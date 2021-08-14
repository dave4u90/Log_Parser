#!/usr/bin/env ruby
require_relative 'log_dashboard'

logfile = ARGV[0]
dashboard = LogDashboard.new(logfile: logfile)
dashboard.show