require 'uri'

# Class responsible for validation and registration of new users.
class UserRegistration
  attr_accessor :user_model, :password_encryptor

  INVALID_EMAIL_ERROR = 'Email is invalid.'.freeze
  EMAIL_IN_USE_ERROR = 'Email is already in use.'.freeze
  INVALID_PASSWORD_ERROR = 'Password must be alphanumeric of minimum length 7 characters.'.freeze
  PASSWORD_MISMATCH_ERROR = "Password and confirmation don't match".freeze

  def initialize(user_model, password_encryptor)
    @user_model = user_model
    @password_encryptor = password_encryptor
  end

  def register(params) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if !valid_email?(params[:email])
      INVALID_EMAIL_ERROR
    elsif user_model.exists?(email: params[:email])
      EMAIL_IN_USE_ERROR
    elsif !valid_password?(params[:password])
      INVALID_PASSWORD_ERROR
    elsif params[:password] != params[:passwordConfirmation]
      PASSWORD_MISMATCH_ERROR
    else
      password_hash = password_encryptor.create(params[:password]).to_s
      user_model.create(email: params[:email], password: password_hash)
      nil
    end
  end

  private

  def valid_email?(email)
    email.match(URI::MailTo::EMAIL_REGEXP).present?
  end

  def valid_password?(password)
    /^(?=.*[a-zA-Z])(?=.*[0-9]).{7,}$/ =~ password
  end
end
