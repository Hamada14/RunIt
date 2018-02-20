require 'sinatra/activerecord'

module Model
  # Description of the User model.
  class User < ActiveRecord::Base
    validates_presence_of :email, :password
    has_many :lambdas
  end
end
