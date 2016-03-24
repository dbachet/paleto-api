require 'rails_helper'

RSpec.describe PalletsController, type: :controller do
  let!(:user) { User.create(email: 'test@test.com', password: '12345678', password_confirmation: '12345678') }

  describe 'GET index' do
    let!(:pallet) { Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: user) }
    it 'assigns @pallets' do
      get :index
      expect(assigns(:pallets)).to eq([pallet])
    end

    it 'returns all pallets' do
      all_pallets = {
        "pallets" =>
        [
          {
            "id"          => 1,
            "title"       => "foo",
            "description" => "bar",
            "latitude"    => "1.111111",
            "longitude"   => "1.111111",
            "comments"    => []
          }
        ]
      }
      get :index
      expect(JSON.parse(response.body)).to eq all_pallets
      expect(response).to be_success
    end
  end

  describe 'GET show' do
    let!(:pallet) { Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: user) }

    it 'assigns @pallet' do
      get :show, id: pallet.id
      expect(assigns(:pallet)).to eq(pallet)
    end

    it 'returns the requested pallet' do
      requested_pallet = {
        "pallet" =>
          {
            "id"          => 1,
            "title"       => "foo",
            "description" => "bar",
            "latitude"    => "1.111111",
            "longitude"   => "1.111111",
            "comments"    => []
          }
        }
      get :show, id: pallet.id
      expect(JSON.parse(response.body)).to eq requested_pallet
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    context 'when valid params' do
      subject { post(:create, pallet: { title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user_id: 1 }) }

      it 'creates a pallet' do
        expect{ subject }.to change{ Pallet.count }.by(1)
      end

      it 'returns the newly created pallet' do
        subject

        new_pallet = {
          "pallet" =>
            {
              "id"          => Pallet.last.id,
              "title"       => "foo",
              "description" => "bar",
              "latitude"    => "1.111111",
              "longitude"   => "1.111111",
              "comments"    => []
            }
          }

        expect(JSON.parse(response.body)).to eq new_pallet
        expect(response).to be_success
      end
    end

    context 'when invalid params' do
      subject { post(:create, pallet: { title: '', description: '', latitude: 1.111111, longitude: 1.111111, user_id: 1 }) }

      it 'does not create a pallet' do
        expect{ subject }.to change{ Pallet.count }.by(0)
      end

      it 'returns errors' do
        errors = {
          "errors" =>
            {
              "title" => ["can't be blank"],
              "description" => ["can't be blank"]
            }
          }

        subject
        expect(JSON.parse(response.body)).to eq(errors)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH update' do
    let(:pallet) { Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: user) }

    context 'when valid params' do
      subject { patch(:update, id: pallet.id, pallet: { title: 'foofoo', description: 'barbar', latitude: 2.222222, longitude: 2.222222 }) }

      it 'updates a pallet' do
        expect{ subject }.to change{ pallet.reload.title }.to('foofoo')
          .and change{ pallet.reload.description }.to('barbar')
          .and change{ pallet.reload.latitude }.to(2.222222)
          .and change{ pallet.reload.longitude }.to(2.222222)
      end

      it 'returns the updated pallet' do
        subject

        updated_pallet = {
          "pallet" =>
            {
              "id"          => Pallet.last.id,
              "title"       => "foofoo",
              "description" => "barbar",
              "latitude"    => "2.222222",
              "longitude"   => "2.222222",
              "comments"    => []
            }
          }

        expect(JSON.parse(response.body)).to eq updated_pallet
        expect(response).to be_success
      end
    end

    context 'when invalid params' do
      subject { patch(:update, id: pallet.id, pallet: { title: '', description: '', latitude: nil, longitude: nil }) }

      it 'does not update a pallet' do
        expect(pallet.reload.title).to eq('foo')
        expect(pallet.reload.description).to eq('bar')
        expect(pallet.reload.latitude).to eq(1.111111)
        expect(pallet.reload.longitude).to eq(1.111111)
      end

      it 'returns errors' do
        errors = {
          "errors" =>
            {
              "title" => ["can't be blank"],
              "description" => ["can't be blank"],
              "latitude" => ["can't be blank"],
              "longitude" => ["can't be blank"]
            }
          }

        subject
        expect(JSON.parse(response.body)).to eq(errors)
        expect(response.status).to eq 422
      end
    end

  end

  describe 'DELETE destroy' do
    let!(:pallet) { Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: user) }
    subject { delete(:destroy, id: pallet.id) }

    it 'destroys pallet' do
      expect{subject}.to change{ Pallet.count }.by(-1)
      expect(response).to be_success
    end
  end
end
