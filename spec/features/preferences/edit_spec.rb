# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Edit preference' do
  subject { visit edit_preference_path(preference) }

  let!(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }

  before do
    sign_in user
    subject
  end

  describe 'render preference form' do
    it 'shows the preference name' do
      within('form') do
        expect(page).to have_field('preference[name]', with: preference.name)
      end
    end

    it 'shows the preference description' do
      within('form') do
        expect(page).to have_field('preference[description]', with: preference.description)
      end
    end

    it 'shows the preference restriction' do
      within('form') do
        expect(page).to have_field('preference[restriction]', checked: preference.restriction)
      end
    end
  end

  describe 'update preference' do
    context 'with valid data' do
      let(:new_name) { 'New Preference Name' }
      let(:new_description) { 'New Preference Description' }
      let(:restriction) { true }

      before do
        fill_in 'preference[name]', with: new_name
        fill_in 'preference[description]', with: new_description
        check 'preference[restriction]'
        click_on 'Update Preference'
      end

      it 'redirects to the preferences index page' do
        expect(page).to have_current_path(preferences_path)
      end

      it 'shows a success message' do
        expect(page).to have_content(I18n.t('views.preferences.update_success'))
      end

      it 'updates the preference name' do
        preference.reload
        expect(preference.name).to eq(new_name)
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
end
