class SessionsController < Devise::SessionsController

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def destroy

    super
  end
end
