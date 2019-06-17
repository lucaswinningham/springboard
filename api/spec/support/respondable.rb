module Helpers
  module Respondable
    def expect_response(status, content_type: 'application/json')
      yield
      expect(response).to have_http_status(status)
      expect(response.content_type).to eq(content_type)
    end

    def response_body
      JSON.parse(response.body, object_class: OpenStruct)
    end

    def response_data
      response_body.data
    end
  end
end
