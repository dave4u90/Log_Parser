#!/usr/bin/env ruby
require 'pry'
require 'colorize'
require_relative 'lib/log_parser'

parser = LogParser.new(logfile: ARGV[0])

if parser.valid?
  parser.parse
  puts "Visit Summary".bold.yellow

  parser.sorted_endpoint_entries.each do |visit_data|
    puts visit_data[:endpoint].green + " " + "#{visit_data[:entry_count]} visits".light_blue
  end

  puts ""

  puts "Unique Visits Summary".bold.yellow

  parser.sorted_controller_path_entries.each do |visit_data|
    puts visit_data[:controller_path].green + " " + "#{visit_data[:entry_count]} visits".light_blue
  end

  puts ""

  puts "Most Frequent Visitors".bold.yellow

  parser.sorted_user_addr_entries.each do |visit_data|
    puts visit_data[:user_addr].green + " " + "#{visit_data[:entry_count]} visits".light_blue
  end
else
  puts parser.errors.red
end