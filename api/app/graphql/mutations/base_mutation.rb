module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    def validation_error(record)
      GraphQL::ExecutionError.new record.errors.full_messages.join "\n"
    end
  end
end
