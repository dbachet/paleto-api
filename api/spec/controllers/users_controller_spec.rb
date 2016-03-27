require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET index' do
    let!(:user) { User.create(email: 'foo@bar.com', password: '12345678', password_confirmation: '12345678') }

    it 'assigns @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end

    it 'returns all users' do
      all_users = {
        "users" =>
        [
          {
            "id"          => 1,
            "email"       => "foo@bar.com"
          }
        ]
      }
      get :index
      expect(JSON.parse(response.body)).to eq all_users
      expect(response).to be_success
    end
  end

  describe 'GET show' do
    let!(:user) { User.create(email: 'foo@bar.com', password: '12345678', password_confirmation: '12345678') }

    it 'assigns @user' do
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end

    it 'returns the requested user' do
      requested_user = {
        "user" =>
          {
            "id"          => 1,
            "email"       => "foo@bar.com"
          }
        }
      get :show, id: user.id
      expect(JSON.parse(response.body)).to eq requested_user
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    let!(:admin) { User.create(email: 'admin@bar.com', password: '12345678', password_confirmation: '12345678', admin: true) }
    before { sign_in admin }

    context 'when valid params' do
      subject { post(:create, user: { email: 'foo@bar.com', password: '12345678', password_confirmation: '12345678' }) }

      it 'creates a user' do
        expect{ subject }.to change{ User.count }.by(1)
      end

      it 'returns the newly created user' do
        subject

        new_user = {
          "user" =>
            {
              "id"          => User.last.id,
              "email"       => "foo@bar.com"
            }
          }

        expect(JSON.parse(response.body)).to eq new_user
        expect(response).to be_success
      end
    end

    context 'when invalid params' do
      subject { post(:create, user: { email: 'foo@bar', password: '12345678', password_confirmation: '12345678' }) }

      it 'does not create a user' do
        expect{ subject }.to change{ User.count }.by(0)
      end

      it 'returns errors' do
        errors = {
          "errors" =>
            {
              "email" => ["is invalid"]
            }
          }

        subject
        expect(JSON.parse(response.body)).to eq(errors)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH update' do
    before { sign_in user }

    let(:user) { User.create(email: 'foo@bar.com', password: '12345678', password_confirmation: '12345678') }

    context 'when valid params' do
      subject { patch(:update, id: user.id, user: { email: 'foofoo@barbar.com' }) }

      it 'updates a user' do
        expect{ subject }.to change{ user.reload.email }.to('foofoo@barbar.com')
      end

      it 'returns the updated user' do
        subject

        updated_user = {
          "user" =>
            {
              "id"          => User.last.id,
              "email"       => "foofoo@barbar.com"
            }
          }

        expect(JSON.parse(response.body)).to eq updated_user
        expect(response).to be_success
      end
    end

    context 'when invalid params' do
      subject { patch(:update, id: user.id, user: { email: 'foo@bar', password: '12345678', password_confirmation: '12345678' }) }

      it 'does not update a user' do
        expect(user.reload.email).to eq('foo@bar.com')
      end

      it 'returns errors' do
        errors = {
          "errors" =>
            {
              "email" => ["is invalid"]
            }
          }

        subject
        expect(JSON.parse(response.body)).to eq(errors)
        expect(response.status).to eq 422
      end
    end

  end

  describe 'DELETE destroy' do
    before { sign_in user }

    let!(:user) { User.create(email: 'foo@bar.com', password: '12345678', password_confirmation: '12345678') }

    subject { delete(:destroy, id: user.id) }

    it 'destroys user' do
      expect{subject}.to change{ User.count }.by(-1)
      expect(response).to be_success
    end
  end
end
