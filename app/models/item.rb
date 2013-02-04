class Item < ActiveRecord::Base
  attr_accessible :count, :crit_count, :description, :item_type, :name, :removed

  validates :count, :crit_count, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :name, :item_type, :description, :crit_count, :presence => true

  has_many :store_activities
end
