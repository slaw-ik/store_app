class StoreActivity < ActiveRecord::Base
  attr_accessible :count, :critical, :item_id, :move_date, :remainder, :user_id, :status_id

  belongs_to :item
  belongs_to :user
  belongs_to :status

  def self.leave(options = {})
    item = options[:item]
    action = options[:action]
    user = options[:user]
    count = options[:count]
    first_count = options[:first_count]

    status_id = case action
                  when :create
                    6
                  when :edit
                    critical = (item.count < item.crit_count ? true : false)
                    if item.count > first_count
                      count = item.count - first_count
                      7
                    else
                      count = first_count - item.count
                      8
                    end
                  when :delete
                    9
                end

    StoreActivity.create(:user_id => user.id,
                         :item_id => item.id,
                         :status_id => status_id,
                         :count => count,
                         :critical => critical,
                         :remainder => item.count,
                         :move_date => Date.today
    )

  end
end
