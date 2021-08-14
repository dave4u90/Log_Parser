require_relative 'log_parser'
require 'colorize'
require 'terminal-table'

class LogDashboard
  attr_accessor :errors
  attr_reader :logfile

  def initialize(logfile:)
    @errors = []
    @logfile = logfile
  end

  def show
    dashboard
    error_dashboard
  end

  def dashboard
    parser = LogParser::Parser.new(logfile: ARGV[0])

    unless parser.valid?
      @errors << parser.errors
      return
    end

    @errors << parser.errors unless parser.perform
    log_entries = parser.log_entries

    dashboard_title = "Log Summary".bold.yellow + ": " + "Total".green + " #{log_entries.count} valid entries".bold.green  + " found".green
    dashboard_table_headers = []
    dashboard_data_row = []

    LogParser::LogEntry::ATTRIBUTES.each do |group_key|
      groups = LogParser::LogEntryGroups.new(log_entries: log_entries, group_by: group_key, sort_groups: true)

      if groups.perform
        case group_key
        when :endpoint
          dashboard_table_headers << "Visit Summary".bold.yellow
        when :controller_path
          dashboard_table_headers << "Unique Visits Summary".bold.yellow
        when :user_addr
          dashboard_table_headers << "Most Frequent Visitors".bold.yellow
        end

        log_entry_groups = group_key == :user_addr ? groups.log_entry_groups.first(5) : groups.log_entry_groups
        table_rows = log_entry_groups.map { |visit_data| [visit_data.group_key.green, visit_data.entry_count] }

        table = Terminal::Table.new(
          rows: table_rows,
          style: {
            border_top: false,
            border_left: false,
            border_right: false,
            border_bottom: false
          }
        )

        dashboard_data_row << table.to_s
      else
        @errors << groups.errors
      end
    end

    dashboard_table = Terminal::Table.new(
      title: dashboard_title,
      headings: dashboard_table_headers,
      rows: [dashboard_data_row],
      style: { border_x: "*".bold.light_blue, border_y: "*".bold.light_blue, border_i: '*'.bold.red }
    )

    puts "\n"
    puts dashboard_table
  end


  def error_dashboard
    unless errors.flatten.empty?
      error_rows = errors.flatten.map { |error| [error[:type], error[:message].red] }
      error_dashboard_title = 'Error Summary'.bold.red + ": " "Total" + " #{error_rows.count} errors".bold + " found while processing the log"

      error_dashboard_table = Terminal::Table.new(
        title: error_dashboard_title,
        headings: ['Error Type'.bold.yellow, 'Error Message'.bold.yellow],
        rows: error_rows,
        style: { border_x: "*".bold.light_blue, border_y: "*".bold.light_blue, border_i: '*'.bold.red }
      )

      puts "\n"
      puts error_dashboard_table
    end
  end
end