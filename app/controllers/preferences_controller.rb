# frozen_string_literal: true

class PreferencesController < ApplicationController
  before_action :set_preference, only: %i[show]

  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  def show; end

  def new
    @preference = Preference.new
  end

  def create
    @preference = current_user.preferences.build(preference_params)

    if @preference.save
      redirect_to preferences_path, notice: t('views.preferences.create_success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_preference
    @preference = current_user.preferences.find(params[:id])
  end

  def preference_params
    params.require(:preference).permit(:name, :description, :restriction)
  end
end
