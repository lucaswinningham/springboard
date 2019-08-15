describe GraphMeta::Objects::Execution::Errors do
  let(:context) do
    query = OpenStruct.new schema: nil
    GraphQL::Query::Context.new query: query, values: nil, object: nil
  end
  subject { GraphMeta::Objects::Execution::Errors.new context: context }

  describe '#add' do
    context 'given one message' do
      it 'should add message' do
        subject.add 'foo'
        expect(subject.to_a).to eq %w[foo]
      end
    end

    context 'given multiple messages' do
      it 'should add messages' do
        subject.add 'foo', 'bar', 'baz'
        expect(subject.to_a).to eq %w[foo bar baz]
      end
    end
  end

  describe '#add_record' do
    let(:foo_model) do
      Class.new do
        include ActiveModel::Validations

        def self.model_name
          ActiveModel::Name.new(self, nil, 'foo')
        end
      end
    end

    it 'should add all error messages for the record' do
      foo_model.class_eval do
        validate :validate_bar
        validate :validate_baz

        def validate_bar
          errors.add :bar, 'bar_invalid'
        end

        def validate_baz
          errors.add :baz, 'baz_invalid'
        end
      end

      record = foo_model.new.tap(&:validate)
      subject.add_record record
      expect(subject.to_a).to eq ['Bar bar_invalid', 'Baz baz_invalid']
    end
  end

  describe '#none?' do
    context 'with no messages added' do
      it 'should return true' do
        expect(subject.none?).to be true
      end
    end

    context 'with one message added' do
      it 'should return false' do
        subject.add 'foo'
        expect(subject.none?).to be false
      end
    end

    context 'with multiple messages added' do
      it 'should return false' do
        subject.add 'bar', 'baz'
        expect(subject.none?).to be false
      end
    end
  end

  describe '#resolve' do
    context 'with messages' do
      before { subject.add 'foo', 'bar', 'baz' }

      it 'should add execution errors to the context for each message except the last one' do
        foo_error = GraphQL::ExecutionError.new 'foo'
        bar_error = GraphQL::ExecutionError.new 'bar'
        expected_errors = [foo_error, bar_error]

        subject.resolve
        expect(context.errors).to eq expected_errors
      end

      it 'should return last error as execution error' do
        baz_error = GraphQL::ExecutionError.new 'baz'
        expect(subject.resolve).to eq baz_error
      end
    end

    context 'without messages' do
      it 'should raise error' do
        error = GraphMeta::Objects::Execution::Errors::ResolveError
        expect { subject.resolve }.to raise_error error
      end
    end
  end
end
