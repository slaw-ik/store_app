class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :invalidate_simultaneous_user_session, :unless => Proc.new {|c| c.controller_name == 'sessions' and c.action_name == 'create' }

  private

  def invalidate_simultaneous_user_session
    sign_out_and_redirect(current_user) if current_user && session[:sign_in_token] != current_user.current_sign_in_token
  end

  def sign_in(resource_or_scope, *args)
    super
    token = Devise.friendly_token
    current_user.update_attribute :current_sign_in_token, token
    session[:sign_in_token] = token
  end

end
