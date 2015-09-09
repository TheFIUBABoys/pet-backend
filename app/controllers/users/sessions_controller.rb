class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /users/sign_in
  # def new
  #   super
  # end

  # POST /users/sign_in
  # def create
  #   super
  # end

  # DELETE /users/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:facebook_id, :facebook_token) }
  end

end
