describe GraphMeta::Mixins::Execution::Resolvable, type: :request do
  let(:klass) do
    Class.new do
      include GraphMeta::Mixins::Execution::Resolvable

      def context
        @context ||= begin
          query = OpenStruct.new schema: nil
          GraphQL::Query::Context.new query: query, values: nil, object: nil
        end
      end
    end
  end

  subject { klass.new }

  describe '#resolve' do
    context 'without #execute implemented' do
      it 'should raise error' do
        expect { subject.resolve }.to raise_error NotImplementedError
      end
    end

    context 'with #execute implemented' do
      before { klass.class_eval { def execute; end } }

      it 'should make given kwargs available as instance variables' do
        subject.resolve one: 1, two: 2

        expect(subject.instance_variable_get(:@one)).to eq 1
        expect(subject.instance_variable_get(:@two)).to eq 2
      end

      it 'should return #execute' do
        klass.class_eval do
          def execute
            'executed'
          end
        end

        expect(subject.resolve).to eq 'executed'
      end

      it 'should run callbacks' do
        klass.class_eval do
          attr_reader :foo

          # the order of these really matter
          before_execute :init_foo, :add_before_to_foo
          after_execute :add_after_to_foo
          around_execute :add_around_to_foo

          def init_foo
            @foo = []
          end

          def add_before_to_foo
            @foo << 'before'
          end

          def add_around_to_foo
            @foo << 'pre_around'
            yield
            @foo << 'post_around'
          end

          def add_after_to_foo
            @foo << 'after'
          end

          def execute
            @foo << 'execute'
          end
        end

        subject.resolve
        expect(subject.foo.join(',')).to eq 'before,pre_around,execute,post_around,after'
      end

      context 'given a callback adds an error' do
        before do
          klass.class_eval do
            before_execute :add_error

            def add_error
              errors.add 'bar'
            end
          end
        end

        it 'should not execute' do
          klass.class_eval do
            attr_reader :foo

            def execute
              @foo = true
            end
          end

          subject.resolve
          expect(subject.foo).to be_nil
        end

        it 'should resolve from errors' do
          errors = GraphMeta::Objects::Execution::Errors.new context: klass.new.context
          errors.add 'bar'
          expected_resolution = errors.resolve
          expect(subject.resolve).to eq expected_resolution
        end

        it 'should not run remaining callbacks' do
          klass.class_eval do
            before_execute :raise_error
            after_execute :raise_error
            around_execute :raise_error

            def raise_error
              raise
            end
          end

          expect { subject.resolve }.not_to raise_error
        end
      end
    end
  end
end
