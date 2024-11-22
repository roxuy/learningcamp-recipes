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
class Preference < ApplicationRecord
  MAX_PREFERENCES = 5

  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :restriction, inclusion: { in: [true, false] }
  validate :preferences_number, on: :create

  def preferences_number
    return unless user && user.preferences.size >= MAX_PREFERENCES

    errors.add(:base, I18n.t('views.preferences.limit_reached_message', max: MAX_PREFERENCES))
  end
end
