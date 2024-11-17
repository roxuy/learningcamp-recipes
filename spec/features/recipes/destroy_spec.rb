# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Destroy recipe' do
  subject { click_on 'Remove' }

  let!(:user) { create(:user) }
  let!(:preference) { create(:preference, user:) }
  let!(:recipe) { create(:recipe, user:) }

  before do
    sign_in user
    visit recipes_path
  end

  it 'shows a delete success message' do
    subject
    expect(page).to have_content(I18n.t('views.recipes.destroy_success'))
  end

  it 'destroy the recipe' do
    expect { subject }.to change(Recipe, :count).by(-1)
  end

  it 'redirects to index' do
    subject
    expect(page).to have_current_path(recipes_path)
  end
end
