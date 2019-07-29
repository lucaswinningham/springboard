module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    # hacky until graphql gem addresses
    # iterate through all messages except the last one, adding each to the context
    # return the last one which will be added to the context by graphql itself
    def validation_error(record)
      error_messages = record.errors.full_messages

      error_messages.first(error_messages.count - 1).each do |error_message|
        context.add_error GraphQL::ExecutionError.new error_message
      end

      GraphQL::ExecutionError.new error_messages.last
    end
  end
end
