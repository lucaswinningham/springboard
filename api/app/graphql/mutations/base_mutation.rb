module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    include Mixins::Execution::Resolvable
  end
end
