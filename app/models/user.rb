class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :activities


  Warden::Manager.before_logout do |user, auth, opts|
    last_act = auth.env["rack.session"]["warden.user.user.session"]["last_request_at"]
    session_token = auth.env["rack.session"]['sign_in_token']
    current_token = user.current_sign_in_token

    status_id = if session_token == current_token
                  if user.timedout?(last_act)
                    5
                  else
                    3
                  end
                else
                  4
                end

    Activity.leave(user.id, status_id, Time.now)
  end

end
