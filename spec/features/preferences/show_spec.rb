# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show preference' do
  subject { visit preference_path(preference) }

  let!(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }

  before do
    sign_in user
    subject
  end

  it 'shows the preference name' do
    within('form') do
      expect(page).to have_field('preference[name]', with: preference.name, disabled: true)
    end
  end

  it 'shows the preference description' do
    within('form') do
      expect(page).to have_field('preference[description]', with: preference.description, disabled: true)
    end
  end

  it 'shows the preference restriction' do
    within('form') do
      expect(page).to have_field('preference[restriction]', with: preference.restriction, disabled: true)
    end
  end
end
