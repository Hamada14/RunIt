require 'sinatra/activerecord'

module Model
  # Description of the User model.
  class Lambda < ActiveRecord::Base
    belongs_to :user
  end
end
