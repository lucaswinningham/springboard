module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    include GraphMeta::Mixins::Execution::Resolvable
  end
end
