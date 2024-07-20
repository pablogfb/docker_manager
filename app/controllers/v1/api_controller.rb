class V1::ApiController < ApplicationController
  
  # Catch exceptions from less to more specific
  rescue_from StandardError do |exception|       
    render json: { status: { code: 503 }, message: exception.message  }, status: 503  
  end      
  rescue_from Docker::Error::NotFoundError, with: :entinty_not_found
  rescue_from Docker::Error::AuthenticationError, with: :authentication_error
  rescue_from Docker::Error::ConflictError, with: :conflict_error
  rescue_from Docker::Error::ClientError, with: :client_error

  private

  def authentication_error
    render json: { status: { code: 403 }, message: 'Athentication error' }, status: :forbidden
  end

  def client_error(exception)
    render json: { status: { code: 503 }, message: exception.message  }, status: 503  
  end

  def conflict_error(exception)
    render json: { status: { code: 422 }, message: exception.message  }, status: 422
  end

  def entinty_not_found
    render json: { status: { code: 404 }, message: 'Docker entity not found' }, status: :not_found
  end
end