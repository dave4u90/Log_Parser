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
end