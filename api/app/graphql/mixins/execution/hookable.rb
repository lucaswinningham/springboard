module Mixins
  module Execution
    module Hookable
      extend ActiveSupport::Concern

      class_methods do
        attr_reader :before_execution_callback_methods
        attr_reader :after_execution_callback_methods

        def before_execution(*methods)
          @before_execution_callback_methods ||= []
          @before_execution_callback_methods.concat methods
        end

        def after_execution(*methods)
          @after_execution_callback_methods ||= []
          @after_execution_callback_methods.concat methods
        end
      end

      private

      def run_before_callbacks
        self.class.before_execution_callback_methods&.each do |method|
          send method if yield
        end
      end

      def run_after_callbacks
        self.class.after_execution_callback_methods&.each do |method|
          send method if yield
        end
      end
    end
  end
end
