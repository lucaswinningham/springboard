require 'logging/formatter'

module Logging
  class Logger < ActiveSupport::Logger
    %w[info debug warn error fatal unknown].each do |logging_method|
      define_method logging_method do |message = nil, tags: [], &block|
        tagged(*tags) { super(message, &block) }
      end
    end

    define_method :ap do |message = nil, level: nil, tags: [], &block|
      tagged(*tags) { super(message, level, &block) }
    end

    def initialize(*args)
      super(*args)
      @formatter = Logging::Formatter.new
    end
  end
end
