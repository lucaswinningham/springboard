shared_examples 'resolvable' do
  subject do
    object = GraphQL::Schema::Object
    context = begin
      query = OpenStruct.new schema: nil
      GraphQL::Query::Context.new query: query, values: nil, object: nil
    end

    described_class.new object: object, context: context
  end

  it 'should implement #execute' do
    expect(subject).to respond_to :execute
  end
end
