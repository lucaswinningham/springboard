module GraphMeta
  module Objects
    module Execution
      class Errors
        attr_reader :context

        def initialize(context:)
          @context = context
        end

        include Enumerable
        def each
          messages.each { |message| yield message }
        end

        def add(*new_messages)
          messages.concat new_messages
        end

        def add_record(record)
          add(*record.errors.full_messages)
        end

        def none?
          messages.empty?
        end

        # hacky until graphql gem addresses
        # iterate through all messages except the last one, adding each to the context
        # return the last one which will be added to the context by graphql itself
        def resolve
          raise ResolveError, 'No error messages to resolve' if none?

          messages.first(messages.count - 1).each do |message|
            context.add_error GraphQL::ExecutionError.new message
          end

          GraphQL::ExecutionError.new messages.last
        end

        private

        def messages
          @messages ||= []
        end

        class ResolveError < StandardError; end
      end
    end
  end
end
