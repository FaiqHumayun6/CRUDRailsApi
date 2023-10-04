# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  respond_to :json
  include RackSessionsFix

  private
  def respond_with(current_user, _opts = {})
    token = current_user.generate_jwt
    render json: {
      status: { 
        status: {code: 200, message: 'Logged in successfully.'},
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes], token: token
      }
    }
  end
  def respond_to_on_destroy
    # Check if the Authorization header is present
    if request.headers['Authorization'].present?
      # Decode the JWT token
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])

      if current_user
        # TODO: You may want to implement a token blacklist here to invalidate the token upon logout
        # For simplicity, we'll just return a success message for now
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    else
      # If Authorization header is not present, return an error response
      render json: {
        status: 401,
        message: 'Unauthorized.'
      }, status: :unauthorized
    end
  end

  def after_sign_in_path_for(resource)
    authenticated_root_path
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
