class Comment < ActiveRecord::Base
  belongs_to :pallet
  belongs_to :user
  validates  :content, :user, :pallet, presence: true
end
