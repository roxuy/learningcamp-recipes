# frozen_string_literal: true

RSpec.describe 'recipes' do
  describe 'GET #show' do
    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user:) }
    let!(:recipe) { create(:recipe, user:) }

    context 'when logged in' do
      before { sign_in user }

      it 'returns a success response' do
        get recipe_path(recipe)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when no logged in' do
      it 'is redirected to login' do
        get recipe_path(recipe)
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
