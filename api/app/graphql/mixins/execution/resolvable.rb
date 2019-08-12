module Mixins
  module Execution
    module Resolvable
      extend ActiveSupport::Concern
      included do
        include Hookable
      end

      def resolve(**kwargs)
        transform_kwargs_into_instance_vars kwargs

        run_before_callbacks { errors.none? }
        execution = execute if errors.none?
        run_after_callbacks { errors.none? }
        return execution if errors.none?

        errors.resolve
      end

      private

      def transform_kwargs_into_instance_vars(**kwargs)
        kwargs.each { |argument, value| instance_variable_set "@#{argument}".to_sym, value }
      end

      def execute
        raise NotImplementedError
      end

      def errors
        @errors ||= Objects::Execution::Errors.new
      end
    end
  end
end
