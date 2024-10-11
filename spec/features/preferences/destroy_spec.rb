# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Destroy preference' do
  subject { click_on 'Remove' }

  let!(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }

  before do
    sign_in user
    visit preferences_path
  end

  it 'shows a delete success message' do
    subject
    expect(page).to have_content(I18n.t('views.preferences.destroy_success'))
  end

  it 'destroy the preference' do
    expect { subject }.to change(Preference, :count).by(-1)
  end

  it 'redirects to index' do
    subject
    expect(page).to have_current_path(preferences_path)
  end
end
