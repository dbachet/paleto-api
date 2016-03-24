class PalletSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :latitude, :longitude

  has_many :comments
  belongs_to :user_id
end
