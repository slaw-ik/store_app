class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  before_filter :invalidate_simultaneous_user_session, :unless => Proc.new { |c| c.controller_name == 'sessions' and c.action_name == 'create' }

  private

  def invalidate_simultaneous_user_session
    if current_user && session[:sign_in_token] != current_user.current_sign_in_token
      sign_out_and_redirect(current_user)
    end
  end

  def sign_in(resource_or_scope, *args)
    super
    token = Devise.friendly_token
    current_user.update_attribute :current_sign_in_token, token
    session[:sign_in_token] = token
    Activity.leave(current_user.id, 1, Time.now)
  end

end
