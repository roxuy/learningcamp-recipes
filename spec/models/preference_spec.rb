# frozen_string_literal: true

# == Schema Information
#
# Table name: preferences
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text             not null
#  restriction :boolean          default(FALSE), not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Preference do
  describe 'validations' do
    subject { build(:preference) }

    context 'when attributes are present' do
      it { is_expected.to be_valid }
    end

    context 'when name is empty' do
      subject { build(:preference, name: '') }

      it { is_expected.not_to be_valid }
    end

    context 'when description is empty' do
      subject { build(:preference, description: '') }

      it { is_expected.not_to be_valid }
    end

    context 'when restriction is empty' do
      subject { build(:preference, restriction: nil) }

      it { is_expected.not_to be_valid }
    end
  end
end
