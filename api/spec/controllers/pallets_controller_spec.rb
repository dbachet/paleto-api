require 'rails_helper'

RSpec.describe PalletsController, type: :controller do
  describe 'GET index' do

    it 'assigns @pallets' do
      pallet = Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user_id: 1)
      get :index
      expect(assigns(:pallets)).to eq([pallet])
    end

    it 'returns all pallets' do
      pallet = Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user_id: 1)
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
    end
  end

  describe 'GET show' do

    it 'assigns @pallet' do
      pallet = Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user_id: 1)
      get :show, id: pallet.id
      expect(assigns(:pallet)).to eq(pallet)
    end

    it 'returns the requested pallet' do
      pallet = Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user_id: 1)
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
    end
  end

  describe 'POST create' do
    context 'when valid params' do
      subject { post(:create, pallet: { title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user_id: 1 }) }

      it 'creates a pallet' do
        # TODO add comments to request params
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

  end

  describe 'DELETE destroy' do

  end
end
