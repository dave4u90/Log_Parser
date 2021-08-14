module LogParser
  class LogEntryGroup
    attr_accessor :group_key, :group_key_name, :entry_count

    def initialize(group_key:, group_key_name:, entry_count:)
      @group_key = group_key
      @group_key_name = group_key_name
      @entry_count = entry_count
    end

    def valid?
      [group_key, group_key_name, entry_count].map(&:to_s).none?(&:empty?)
    end
  end
end