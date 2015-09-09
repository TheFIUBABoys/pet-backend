class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /users/sign_in
  # def new
  #   super
  # end

  # POST /users/sign_in
  def create
    if params.fetch(:user).fetch(:facebook_id, nil)
      facebook_sign_in!
     else
       super
    end
  end

  # DELETE /users/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:email, :password, :facebook_id, :facebook_token)
    end
  end

  def facebook_sign_in!
    user = User.find_by(params.fetch(:user))
    if user
      render json: user
    else
      render json: { error: "Invalid id or token" },
             status: :unprocessable_entity
    end
  end

end
