module Helpers
  module Respondable
    def body
      @body ||= JSON.parse(response.body, object_class: OpenStruct)
    end

    def data
      @data ||= body.data
    end

    def errors
      @errors ||= body.errors
    end
  end
end
