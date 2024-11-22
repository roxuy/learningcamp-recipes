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

  describe 'DELETE #destroy' do
    subject { delete recipe_path(recipe) }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user:) }
    let!(:recipe) { create(:recipe, user:) }

    context 'when logged in' do
      before { sign_in user }

      it 'is redirected' do
        subject
        expect(response).to have_http_status(:redirect)
      end

      it 'deletes the recipe' do
        expect { subject }.to change(Recipe, :count).by(-1)
      end
    end

    context 'when recipe not belongs to the user' do
      let!(:other_user) { create(:user) }

      before { sign_in other_user }

      it 'returns a not found response' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when no logged in' do
      it 'is redirected' do
        subject
        expect(response).to have_http_status(:redirect)
      end

      it 'does not delete the recipe' do
        expect { subject }.not_to change(Recipe, :count)
      end
    end
  end
end
