module GraphMeta
  module Mixins
    module Execution
      module Resolvable
        extend ActiveSupport::Concern

        included do
          include ActiveSupport::Callbacks
          define_callbacks :execute
        end

        class_methods do
          ActiveSupport::Callbacks::CALLBACK_FILTER_TYPES.each do |filter_type|
            define_method "#{filter_type}_execute" do |*methods|
              methods.each do |method|
                set_callback :execute, filter_type, method, if: :no_errors?
              end
            end
          end
        end

        def resolve(**kwargs)
          transform_kwargs_into_instance_vars kwargs

          execution = run_callbacks :execute do
            execute if no_errors?
          end

          errors.none? ? execution : errors.resolve
        end

        def errors
          @errors ||= Objects::Execution::Errors.new context: context
        end

        private

        def no_errors?
          errors.none?
        end

        def transform_kwargs_into_instance_vars(**kwargs)
          kwargs.each { |argument, value| instance_variable_set "@#{argument}".to_sym, value }
        end

        def execute
          raise NotImplementedError
        end
      end
    end
  end
end
