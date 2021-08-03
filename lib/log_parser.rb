require 'pry'

class LogParser
  attr_reader :logfile, :errors

  def initialize(logfile:)
    begin
      @logfile = File.open(logfile)
    rescue Errno::ENOENT => e
      @errors = e.message
    end
  end

  def valid?
    errors.nil?
  end

  def parse
    @parsed_data ||= logfile.map do |log|
      endpoint, user_addr = log.split(' ')
      controller_path = "/#{endpoint.split('/')[1]}"

      { endpoint: endpoint, controller_path: controller_path, user_addr: user_addr}
    end
  end

  def entry_counts_by_endpoint
    @parsed_data.group_by { |entry| entry[:endpoint] }.map do |endpoint, entries|
      { endpoint: endpoint, entry_count: entries.count }
    end
  end

  def entry_counts_by_controller_path
    @parsed_data.group_by { |entry| entry[:controller_path] }.map do |controller_path, entries|
      { controller_path: controller_path, entry_count: entries.count }
    end
  end

  def entry_counts_by_user_addr
    @parsed_data.group_by { |entry| entry[:user_addr] }.map do |user_addr, entries|
      { user_addr: user_addr, entry_count: entries.count }
    end
  end
end