require 'rails_helper'
require 'pundit/rspec'

RSpec.describe CommentPolicy do
  let(:admin) { User.create(email: 'test1@test.com', password: '12345678', password_confirmation: '12345678', admin: true) }
  let(:comment_creator) { User.create(email: 'test2@test.com', password: '12345678', password_confirmation: '12345678') }
  let(:another_user) { User.create(email: 'test3@test.com', password: '12345678', password_confirmation: '12345678') }
  let(:pallet) { Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: another_user) }
  let(:comment) { Comment.create(content: 'foofoo', user: comment_creator, pallet: pallet) }
  let(:guest) { nil }

  subject { described_class }

  permissions :update?, :destroy? do
    it 'denies access if guest user or user is not the creator of the comment' do
      expect(subject).not_to permit(another_user, comment)
      expect(subject).not_to permit(guest, comment)
    end

    it 'grants access if user is an admin or if user is the creator of the comment' do
      expect(subject).to permit(admin, comment)
      expect(subject).to permit(comment_creator, comment)
    end
  end

  permissions :create? do
    it 'denies access if guest user' do
      expect(subject).not_to permit(guest, Comment.new)
    end

    it 'grants access if user logged in' do
      expect(subject).to permit(admin, Comment.new)
      expect(subject).to permit(comment_creator, Comment.new)
      expect(subject).to permit(another_user, Comment.new)
    end
  end
end
