module Logging
  class Formatter < Logger::Formatter
    include ActiveSupport::TaggedLogging::Formatter
    SEVERITY_COLOR_MAP = {
      'INFO' => `tput setaf 4`,
      'DEBUG' => nil,
      'WARN' => `tput setaf 228`,
      'ERROR' => `tput setaf 1`,
      'FATAL' => `tput setaf 209`,
      'ANY' => `tput setaf 5`
    }.freeze

    def call(severity, timestamp, _progname, msg)
      time = timestamp.strftime('%Y-%m-%dT%H:%M:%S.%3N')
      color = SEVERITY_COLOR_MAP[severity]
      message = msg2str(msg)

      "#{reset}#{color}[#{time}] #{tags_text}#{severity}: #{reset}#{message}\n"
    end

    private

    def reset
      `tput sgr0`
    end
  end
end
