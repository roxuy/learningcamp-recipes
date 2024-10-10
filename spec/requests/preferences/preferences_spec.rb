# frozen_string_literal: true

RSpec.describe 'preferences' do
  describe 'GET #show' do
    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user:) }

    context 'when logged in' do
      before { sign_in user }

      it 'returns a success response' do
        get preference_path(preference)
        expect(response).to have_http_status(:success)
      end
    end

    context 'when no logged in' do
      it 'is redirected to login' do
        get preference_path(preference)
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
