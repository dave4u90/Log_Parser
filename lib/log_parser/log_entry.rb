module LogParser
  class LogEntry
    ATTRIBUTES = [:endpoint, :controller_path, :user_addr].freeze

    attr_reader *ATTRIBUTES

    def initialize(endpoint:, controller_path:, user_addr:)
      @endpoint = endpoint
      @controller_path = controller_path
      @user_addr = user_addr
    end

    def valid?
      [@endpoint, @controller_path, @user_addr].map(&:to_s).none?(&:empty?)
    end

    def controller_path
      "/#{@controller_path}"
    end
  end
end