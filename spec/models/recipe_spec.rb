# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text             not null
#  ingredients :string           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Recipe do
  describe 'validations' do
    subject { build(:recipe) }

    context 'when attributes are present' do
      it { is_expected.to be_valid }
    end

    context 'when name is empty' do
      subject { build(:recipe, name: '') }

      it { is_expected.not_to be_valid }
    end

    context 'when description is empty' do
      subject { build(:recipe, description: '') }

      it { is_expected.not_to be_valid }
    end

    context 'when ingredients is empty' do
      subject { build(:recipe, ingredients: '') }

      it { is_expected.not_to be_valid }
    end
  end
end
