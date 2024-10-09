# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Destroy preference' do
  subject { delete reference_path(preference) }

  let!(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }

  before do
    sign_in user
    subject
  end

    context 'with preference belongs to user' do
      before do
        click_on 'Delete Preference'
      end

      it 'destroy de preference' do
        expect(page).to have_current_path(preferences_path)
      end

      it 'shows a success message' do
        expect(page).to have_content(I18n.t('views.preferences.delete_success'))
      end

      it 'redirect to preference index page' do
        expect(page).to have_current_path(preferences_path)
      end

      it 'updates the preference description' do
        preference.reload
        expect(preference.description).to eq(new_description)
      end

      it 'updates the preference restriction' do
        preference.reload
        expect(preference.restriction).to eq(restriction)
      end
    end

    context 'with invalid data' do
      let(:invalid_name) { '' }
      let(:invalid_description) { '' }

      before do
        fill_in 'preference[name]', with: invalid_name
        fill_in 'preference[description]', with: invalid_description
        click_on 'Update Preference'
      end

      it 'renders the form' do
        within('form') do
          expect(page).to have_field('preference[name]', with: invalid_name)
          expect(page).to have_field('preference[description]', with: invalid_description)
        end
      end

      it 'renders the error messages' do
        expect(page).to have_text("Name can't be blank", wait: 5)
        expect(page).to have_text("Description can't be blank", wait: 5)
      end
    end
end
