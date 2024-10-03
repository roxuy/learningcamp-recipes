# frozen_string_literal: true

class PreferencesController < ApplicationController
  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  def new
    @preference = current_user.preferences.build
  end

  def create
    @preference = current_user.preferences.build(preference_params)

    if @preference.save
      redirect_to preferences_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def preference_params
    params.require(:preference).permit(:name, :description, :restriction)
  end
end
