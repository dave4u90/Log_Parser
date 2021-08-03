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
end