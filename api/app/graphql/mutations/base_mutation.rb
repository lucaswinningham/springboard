module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    class << self
      attr_reader :before_mutation_callback_methods
      attr_reader :after_mutation_callback_methods

      def before_mutation(*methods)
        @before_mutation_callback_methods ||= []
        @before_mutation_callback_methods.concat methods
      end

      def after_mutation(*methods)
        @after_mutation_callback_methods ||= []
        @after_mutation_callback_methods.concat methods
      end
    end

    def resolve(**kwargs)
      transform_kwargs_into_instance_vars kwargs

      run_before_callbacks if errors.none?
      mutation = mutate if errors.none?
      run_after_callbacks if errors.none?
      return mutation if errors.none?

      errors.resolve
    end

    def mutate
      raise NotImplementedError
    end

    def errors
      @errors ||= MutationErrors.new
    end

    private

    def transform_kwargs_into_instance_vars(**kwargs)
      kwargs.each { |argument, value| instance_variable_set "@#{argument}".to_sym, value }
    end

    def run_before_callbacks
      self.class.before_mutation_callback_methods&.each do |method|
        send method if errors.none?
      end
    end

    def run_after_callbacks
      self.class.after_mutation_callback_methods&.each do |method|
        send method if errors.none?
      end
    end

    class MutationErrors
      def initialize
        @messages = []
      end

      include Enumerable
      def each
        yield messages
      end

      def add(*new_messages)
        messages.concat new_messages
      end

      def add_record(record)
        add record.errors.full_messages
      end

      def none?
        messages.empty?
      end

      # hacky until graphql gem addresses
      # iterate through all messages except the last one, adding each to the context
      # return the last one which will be added to the context by graphql itself
      def resolve
        messages.first(messages.count - 1).each do |message|
          context.add_error GraphQL::ExecutionError.new message
        end

        GraphQL::ExecutionError.new messages.last
      end

      private

      attr_accessor :messages
    end
  end
end
