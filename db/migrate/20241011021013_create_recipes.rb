# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :ingredients, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
