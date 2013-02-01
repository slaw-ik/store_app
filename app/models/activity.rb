class Activity < ActiveRecord::Base
  attr_accessible :status_id, :user_id, :at_time

  belongs_to :statuses
  belongs_to :user

  def self.leave(user_id, status_id, at_time)
    Activity.create(:user_id => user_id, :status_id => status_id, :at_time => at_time)
  end
end
