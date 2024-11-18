# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create preference' do
  let!(:user) { create(:user) }
  let!(:preference) { build(:preference, user:) }

  before do
    sign_in user
    visit new_preference_path
    fill_in 'preference[name]', with: preference[:name]
    fill_in 'preference[description]', with: preference[:description]
    click_on 'Create Preference'
  end

  context 'with valid data' do
    it 'redirects to the preferences index page' do
      expect(page).to have_current_path(preferences_path)
    end

    it 'shows a success message' do
      expect(page).to have_content(I18n.t('views.preferences.create_success'))
    end

    it 'creates the preference' do
      expect(Preference.count).to eq(1)
    end
  end

  context 'when the user has reached the maximum number of preferences' do
    let!(:user_with_max_preferences) { create(:user) }
    let!(:preference) { build(:preference) }

    before do
      create_list(:preference, Preference::MAX_PREFERENCES, user: user_with_max_preferences)
      sign_in user_with_max_preferences
      visit new_preference_path
      fill_in 'preference[name]', with: preference[:name]
      fill_in 'preference[description]', with: preference[:description]
      click_on 'Create Preference'
    end

    it 'render the error message' do
      expect(page).to have_content(I18n.t('views.preferences.limit_reached_message', max: Preference::MAX_PREFERENCES))
    end

    it 'do not creates the preference' do
      expect(Preference.where(user: user_with_max_preferences).count).to eq(Preference::MAX_PREFERENCES)
    end
  end
end
