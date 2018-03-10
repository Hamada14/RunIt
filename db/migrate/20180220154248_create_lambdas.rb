# frozen_string_literal: true

# Migration class for Lambdas table.
class CreateLambdas < ActiveRecord::Migration[5.1]
  def up
    create_table :lambdas do |t|
      t.string :name
      t.text :code
      t.integer :user_id
      t.datetime :created_at, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end

  def down
    drop_table :lambdas
  end
end
