class Pallet < ActiveRecord::Base
  has_many   :comments
  belongs_to :user
  validates  :title, :description, :latitude, :longitude, :user, presence: true
end
