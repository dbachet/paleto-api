require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { User.create(email: 'test@test.com', password: '12345678', password_confirmation: '12345678') }
  let!(:pallet) { Pallet.create(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: user) }

  describe 'GET index' do
    let!(:comment) { Comment.create(content: 'foo', user: user, pallet: pallet) }

    it 'assigns @comments' do
      get :index
      expect(assigns(:comments)).to eq([comment])
    end

    it 'returns all comments' do
      all_comments = {
        "comments" =>
        [
          {
            "id"        => comment.id,
            "content"   => "foo"
          }
        ]
      }
      get :index
      expect(JSON.parse(response.body)).to eq all_comments
      expect(response).to be_success
    end
  end

  describe 'GET show' do
    let(:comment) { Comment.create(content: 'foo', user: user, pallet: pallet) }

    it 'assigns @comment' do
      get :show, id: comment.id
      expect(assigns(:comment)).to eq(comment)
    end

    it 'returns the requested comment' do
      requested_comment = {
        "comment" =>
          {
            "id"        => comment.id,
            "content"   => "foo"
          }
        }
      get :show, id: comment.id
      expect(JSON.parse(response.body)).to eq requested_comment
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    context 'when valid params' do
      subject { post(:create, comment: { content: 'foo', user_id: user.id, pallet_id: pallet.id }) }

      it 'creates a comment' do
        expect{ subject }.to change{ Comment.count }.by(1)
      end

      it 'returns the newly created comment' do
        subject

        new_comment = {
          "comment" =>
            {
              "id"        => Comment.last.id,
              "content"   => "foo"
            }
          }

        expect(JSON.parse(response.body)).to eq new_comment
        expect(response).to be_success
      end
    end

    context 'when invalid params' do
      subject { post(:create, comment: { content: '', user_id: user.id, pallet_id: pallet.id }) }

      it 'does not create a comment' do
        expect{ subject }.to change{ Comment.count }.by(0)
      end

      it 'returns errors' do
        errors = {
          "errors" =>
            {
              "content" => ["can't be blank"]
            }
          }

        subject
        expect(JSON.parse(response.body)).to eq(errors)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'PATCH update' do
    let(:comment) { Comment.create(content: 'foo', user_id: user.id, pallet_id: pallet.id) }

    context 'when valid params' do
      subject { patch(:update, id: comment.id, comment: { content: 'foofoo' }) }

      it 'updates a comment' do
        expect{ subject }.to change{ comment.reload.content }.to('foofoo')
      end

      it 'returns the updated comment' do
        subject

        updated_comment = {
          "comment" =>
            {
              "id"        => Comment.last.id,
              "content"   => "foofoo"
            }
          }

        expect(JSON.parse(response.body)).to eq updated_comment
        expect(response).to be_success
      end
    end

    context 'when invalid params' do
      subject { patch(:update, id: comment.id, comment: { content: '' }) }

      it 'does not update a comment' do
        expect(comment.reload.content).to eq('foo')
      end

      it 'returns errors' do
        errors = {
          "errors" =>
            {
              "content" => ["can't be blank"],
            }
          }

        subject
        expect(JSON.parse(response.body)).to eq(errors)
        expect(response.status).to eq 422
      end
    end

  end

  describe 'DELETE destroy' do
    let!(:comment) { Comment.create(content: 'foo', user_id: user.id, pallet_id: pallet.id) }

    subject { delete(:destroy, id: comment.id) }

    it 'assigns @comment' do
      subject
      expect(assigns(:comment)).to eq(comment)
    end

    it 'destroys comment' do
      expect{subject}.to change{ Comment.count }.by(-1)
      expect(response).to be_success
    end
  end
end
