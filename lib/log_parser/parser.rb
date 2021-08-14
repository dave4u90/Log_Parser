require_relative 'log_entry'

module LogParser
  class Parser
    attr_reader :logfile, :errors, :log_entries

    def initialize(logfile:)
      @log_entries = []
      @errors = []

      begin
        @logfile = File.open(logfile)
      rescue Errno::ENOENT => e
        @errors << { type: 'InvalidFilePath', message: e.message }
      end
    end

    def valid?
      errors.empty?
    end

    def perform
      return false unless valid?

      @parsed_data ||= logfile.map do |log|
        endpoint, user_addr = log.split(/\s/)
        controller_path = endpoint.split('/')[1]
        entry_data = { endpoint: endpoint, controller_path: controller_path, user_addr: user_addr }
        entry = LogParser::LogEntry.new(**entry_data)

        if entry.valid?
          @log_entries << entry
        else
          @errors << { type: entry.class, message: "#{entry_data} is not a valid log entry" }
        end
      end

      valid?
    end
  end
end
