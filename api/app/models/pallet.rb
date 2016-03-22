class Pallet < ActiveRecord::Base
  validates :title, :description, :latitude, :longitude, presence: true
end
