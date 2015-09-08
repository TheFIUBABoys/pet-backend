class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == "application/json" }

  before_action :authenticate_user_from_token!
  before_action :authenticate_user!

  private

  def authenticate_admin_user!
    authenticate_user! unless request.format.json?
  end

  def authenticate_user_from_token!
    user_token = params[:user_token].presence
    user       = user_token && User.find_by(authentication_token: user_token.to_s)

    sign_in(user, store: false) if user
  end
end
