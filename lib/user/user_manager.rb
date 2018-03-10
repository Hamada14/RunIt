# frozen_string_literal: true

require 'uri'

module User
  # Class responsible for validation and registration of new users.
  class UserManager
    attr_accessor :user_model, :password_encryptor, :registration_validator

    INVALID_LOGIN_ERROR = 'The provided credentials are invalid'

    def initialize(user_model, password_encryptor, registration_validator)
      @user_model = user_model
      @password_encryptor = password_encryptor
      @registration_validator = registration_validator
    end

    def register(params)
      errors = registration_validator.valid_params?(params)
      return errors unless errors.empty?
      password_hash = password_encryptor.create(params[:password]).to_s
      user_model.create(
        email: params[:email],
        password: password_hash,
        first_name: params[:firstName],
        last_name: params[:lastName]
      )
      {}
    end

    def login(params)
      user = user_model.find_by(email: params[:email])
      return INVALID_LOGIN_ERROR unless user
      password_hash = password_encryptor.new(user[:password])
      return INVALID_LOGIN_ERROR unless password_hash == params[:password]
    end

    def get_id(email)
      user_model.find_by(email: email)[:id]
    end
  end
end
