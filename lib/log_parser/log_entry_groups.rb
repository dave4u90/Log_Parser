require_relative 'log_entry'
require_relative 'log_entry_group'
module LogParser
  class LogEntryGroups
    attr_accessor :log_entries, :group_by, :sort_groups
    attr_reader :log_entry_groups, :errors

    def initialize(log_entries:, group_by:, sort_groups: false)
      @log_entries = log_entries || []
      @group_by = group_by
      @log_entry_groups = []
      @sort_groups = sort_groups
      @errors = []
    end

    def valid?
      !log_entries.empty? &&
        log_entries.is_a?(Array) &&
        log_entries.all? { |entry| entry.is_a?(LogParser::LogEntry) } &&
        !group_by.empty? &&
        LogParser::LogEntry::ATTRIBUTES.include?(group_by)
    end

    def perform
      return false unless valid?

      groups = log_entries.group_by { |log_entry| log_entry.public_send(group_by) }

      groups.map do |key, log_entries|
        entry_data = { group_key: key, group_key_name: group_by, entry_count: log_entries.count }
        log_entry_group = LogParser::LogEntryGroup.new(**entry_data)

        if log_entry_group.valid?
          @log_entry_groups << log_entry_group
        else
          @errors << { type: log_entry_group.class.name, message: "#{entry_data} is not a valid log group" }
        end
      end

      sort_group_by_entry_count if sort_groups

      errors.empty?
    end

    private

    def sort_group_by_entry_count
      @log_entry_groups = log_entry_groups.sort_by { |group| group.entry_count }.reverse
    end
  end
end