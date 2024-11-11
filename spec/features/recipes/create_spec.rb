# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create recipe' do
  subject { visit new_recipe_path }

  let!(:user) { create(:user) }

  before do
    sign_in user
    subject
  end

  describe 'render new recipe form' do
    it 'shows ingredients field' do
      within('form') do
        expect(page).to have_field('recipe[ingredients]')
      end
    end
  end

  describe 'create recipe' do
    context 'with valid data' do
      let(:ingredients) { Array.new(3) { Faker::Food.ingredient }.join(', ') }

      before do
        stub_request(:post, 'https://api.openai.com/v1/chat/completions')
          .with(
            body: {
              model: 'gpt-3.5-turbo-1106',
              messages: [
                { role: 'system',
                  content: "Write a recipe following these rules:\n" \
                           "1) The recipe MUST include only the ingredients provided.\n" \
                           "2) Your response MUST be in JSON format, as this example:\n" \
                           "{ \"name\": \"Dish Name\",\n  \"content\": \"Recipe instructions\" }\n" },
                { role: 'user', content: "Ingredients: #{ingredients}" }
              ],
              temperature: 0.0
            }.to_json,
            headers: {
              'Authorization' => "Bearer #{ENV.fetch('OPENAI_API_KEY', nil)}",
              'Content-Type' => 'application/json'
            }
          ).to_return(
            status: 200,
            body: {
              choices: [
                {
                  message: {
                    content: {
                      name: 'Tomato Bread',
                      content: "Write a recipe following these rules:\n" \
                               "1) The recipe MUST include only the ingredients provided.\n" \
                               "2) Your response MUST be in JSON format, as this example:\n" \
                               "{ \"name\": \"Dish Name\",\n  \"content\": \"Recipe instructions\" }\n"
                    }.to_json
                  }
                }
              ]
            }.to_json
          )
        fill_in 'recipe[ingredients]', with: ingredients
        click_on 'Create Recipe'
      end

      it 'redirects to the recipes index page' do
        expect(page).to have_current_path(recipes_path)
      end

      it 'shows a success message' do
        expect(page).to have_content(I18n.t('views.recipes.create_success'))
      end
    end
  end
end
