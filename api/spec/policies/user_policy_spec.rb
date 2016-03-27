require 'rails_helper'
require 'pundit/rspec'

RSpec.describe UserPolicy do
  let(:admin) { User.create(email: 'test1@test.com', password: '12345678', password_confirmation: '12345678', admin: true) }
  let(:user) { User.create(email: 'test2@test.com', password: '12345678', password_confirmation: '12345678') }
  let(:another_user) { User.create(email: 'test3@test.com', password: '12345678', password_confirmation: '12345678') }
  let(:guest) { nil }

  subject { described_class }

  permissions :update?, :destroy? do
    it 'denies access if guest user or user is not the current user' do
      expect(subject).not_to permit(another_user, user)
      expect(subject).not_to permit(guest, user)
    end

    it 'grants access if user is an admin or if user is current user' do
      expect(subject).to permit(admin, user)
      expect(subject).to permit(user, user)
    end
  end

  permissions :create? do
    it 'denies access if guest user' do
      expect(subject).not_to permit(guest, User.new)
      expect(subject).not_to permit(user, User.new)
      expect(subject).not_to permit(another_user, User.new)
    end

    it 'grants access if user logged in' do
      expect(subject).to permit(admin, User.new)
    end
  end
end
