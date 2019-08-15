require 'examples/graphql/graph_meta/mixins/resolvable_example'

describe GraphMeta::Mixins::Execution::Resolvable, type: :request do
  it_behaves_like 'resolvable'
end
