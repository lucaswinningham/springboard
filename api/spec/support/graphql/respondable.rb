module Support
  module GraphQL
    module Respondable
      def body
        @body = JSON.parse(response.body, object_class: OpenStruct)
      end

      def data
        @data = body.data
      end

      def errors
        @errors = body.errors
      end

      def error_messages
        @error_messages = errors.map(&:message)
      end
    end
  end
end
