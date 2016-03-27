require 'rails_helper'
require 'pundit/rspec'

RSpec.describe PalletPolicy do
  let(:admin) { User.create(email: 'test1@test.com', password: '12345678', password_confirmation: '12345678', admin: true) }
  let(:pallet_creator) { User.create(email: 'test2@test.com', password: '12345678', password_confirmation: '12345678') }
  let(:another_user) { User.create(email: 'test3@test.com', password: '12345678', password_confirmation: '12345678') }
  let(:pallet) { Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: pallet_creator) }
  let(:guest) { nil }

  subject { described_class }

  permissions :update?, :destroy? do
    it 'denies access if guest user or user is not the creator of the pallet' do
      expect(subject).not_to permit(another_user, pallet)
      expect(subject).not_to permit(guest, pallet)
    end

    it 'grants access if user is an admin or if user is the creator of the pallet' do
      expect(subject).to permit(admin, pallet)
      expect(subject).to permit(pallet_creator, pallet)
    end
  end

  permissions :create? do
    it 'denies access if guest user' do
      expect(subject).not_to permit(guest, Pallet)
    end

    it 'grants access if user logged in' do
      expect(subject).to permit(admin, Pallet.new)
      expect(subject).to permit(pallet_creator, Pallet.new)
      expect(subject).to permit(another_user, Pallet.new)
    end
  end
end
