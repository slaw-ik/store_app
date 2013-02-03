class Item < ActiveRecord::Base
  attr_accessible :count, :crit_count, :description, :item_type, :name

  has_many :store_activities
end
