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

  describe 'GET #edit' do
    subject { get edit_preference_path(preference) }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user:) }

    context 'when logged in' do
      before { sign_in user }

      it 'returns a success response' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'includes the preference name' do
        subject
        expect(response.body).to include(preference.name)
      end
    end

    context 'when no logged in' do
      it 'is redirected to login' do
        subject
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'PATCH #update' do
    subject { patch preference_path(preference), params: { preference: attributes } }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user:) }
    let(:attributes) do
      {
        name: 'New Name',
        description: 'New Description',
        restriction: true
      }
    end

    context 'when logged in' do
      before { sign_in user }

      context 'with valid data' do
        it 'is redirected' do
          subject
          expect(response).to have_http_status(:redirect)
        end
      end

      context 'with invalid data' do
        let(:attributes) do
          {
            name: '',
            description: '',
            restriction: nil
          }
        end

        it 'return unprocessable entity' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when no logged in' do
      it 'is redirected to login' do
        subject
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete preference_path(preference) }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user:) }

    context 'when logged in' do

      before { sign_in user }

      it 'is redirected' do
        subject
        expect(response).to have_http_status(:redirect)
      end

      it 'deletes the preference' do
        expect { subject }.to change(Preference, :count).by(-1)
      end
    end

    context 'when preference not belongs to the user' do
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

      it 'does not delete the preference' do
        expect { subject }.not_to change(Preference, :count)  
      end  
    end
  end
end
