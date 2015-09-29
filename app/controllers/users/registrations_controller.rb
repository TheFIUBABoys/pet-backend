class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]
  skip_before_filter :authenticate_scope!, only: [:update]

  # GET /users/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if facebook_params? && user = User.find_by(facebook_id: facebook_params[:facebook_id])
      user.update_attributes(facebook_token: facebook_params[:facebook_token])
      render json: user
    else
      super
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    respond_to do |format|
      format.html do
        super
      end
      format.json do
        if current_user
          super
          @user = User.find_by(id: current_user.id)
        else
          render json: {}, status: :unauthorized
        end
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:facebook_id, :facebook_token, :email, :password, :password_confirmation, :first_name, :last_name,
               :location, :phone)
    end
  end

  def facebook_params?
    facebook_params[:facebook_id] && facebook_params[:facebook_token]
  end

  def facebook_params
    params.fetch(:user).slice(:facebook_id, :facebook_token)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:facebook_id, :facebook_token, :email, :first_name, :last_name, :location, :phone)
    end
  end

  # Overwrite to update without password.
  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
