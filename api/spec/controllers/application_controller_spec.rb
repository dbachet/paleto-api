require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  controller do
    def index
      raise Pundit::NotAuthorizedError
    end
  end

  describe 'handling AccessDenied exceptions' do
    it 'renders json with error' do
      errors = {
        'errors' =>
          {
            'base' => ['Access denied']
          }
        }

      get :index
      expect(JSON.parse(response.body)).to eq(errors)
      expect(response.status).to eq 403
    end
  end
end
