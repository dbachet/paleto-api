class PalletSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :latitude, :longitude

  has_many :comments
  has_one :user
end
