class GraphqlController < ApplicationController
  def execute
    result = ApiSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )

    render json: result, status: :ok
  rescue StandardError => e
    internal_server_error e
  end

  private

  def query
    params[:query]
  end

  def variables
    ensure_hash(params[:variables])
  end

  def context
    {
      # Query context goes here, for example:
      # current_user: current_user,
    }
  end

  def operation_name
    params[:operationName]
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def internal_server_error(error)
    raise e unless Rails.env.development?

    logger.error error.message
    logger.error error.backtrace.join "\n"

    error_json = { error: { message: error.message, backtrace: error.backtrace }, data: nil }
    render json: error_json, status: :internal_server_error
  end
end
