class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content

  belongs_to :user_id
  belongs_to :pallet_id
end
