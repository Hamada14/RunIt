# frozen_string_literal: true

# Migration file for creating the User table.
class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.datetime :created_at, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end

  def down
    drop_table :users
  end
end
