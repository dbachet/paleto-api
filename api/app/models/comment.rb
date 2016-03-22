class Comment < ActiveRecord::Base
  belongs_to :pallet
  belongs_to :user
end
