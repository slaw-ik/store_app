class Status < ActiveRecord::Base
  attr_accessible :id, :name

  has_many :activities
  has_many :store_activities
end
