# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Show recipe' do
  subject { visit recipe_path(recipe) }

  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe, user:) }

  before do
    sign_in user
    subject
  end

  it 'shows the recipe name' do
    within('form') do
      expect(page).to have_field('recipe[name]', with: recipe.name, disabled: true)
    end
  end

  it 'shows the recipe description' do
    within('form') do
      textarea = find('textarea', text: recipe.description, match: :first)
      expect(textarea.value.strip).to eq(recipe.description.strip)
    end
  end
end
