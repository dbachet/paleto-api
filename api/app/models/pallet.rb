class Pallet < ActiveRecord::Base
  has_many   :comments
  belongs_to :user
  validates  :title, :description, :latitude, :longitude, presence: true
end
