class API::V1::Users::SessionsController < Devise::SessionsController
  include ActionController::MimeResponds
  respond_to :json

  def destroy
    super
  end

  private

  def respond_with(_resource, _opts = {})
    render json: { ok: true }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end