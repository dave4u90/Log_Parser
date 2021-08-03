#!/usr/bin/env ruby

require_relative 'lib/log_parser'

parser = LogParser.new(logfile: ARGV[0])