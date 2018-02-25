module User
  # Responsible for the validation of registration.
  class RegistrationValidator
    attr_accessor :user_model

    INVALID_EMAIL_ERROR = 'Email is invalid.'.freeze
    EMAIL_IN_USE_ERROR = 'Email is already in use.'.freeze
    INVALID_PASSWORD_ERROR = 'Password must be alphanumeric of minimum length 7 characters.'.freeze
    PASSWORD_MISMATCH_ERROR = "Password and confirmation don't match".freeze
    INVALID_NAME_ERROR = 'Name must be between 5 and 20 characters with no space.'.freeze

    def initialize(user_model)
      @user_model = user_model
    end

    def valid_params?(params) # rubocop:disable Metrics/AbcSize
      {
        email: validate_email_pattern(params[:email]) || validate_new_email(params[:email]),
        password: validate_password(params[:password]),
        passwordConfirmation:
          validate_password_confirmation(params[:password], params[:passwordConfirmation]),
        firstName: validate_name(params[:firstName]),
        lastName: validate_name(params[:lastName])
      }.delete_if { |_, v| v.nil? }
    end

    private

    def validate_email_pattern(email)
      return INVALID_EMAIL_ERROR if email.nil? || email.match(URI::MailTo::EMAIL_REGEXP).blank?
    end

    def validate_new_email(email)
      return EMAIL_IN_USE_ERROR if user_model.exists?(email: email)
    end

    def validate_password(password)
      return INVALID_PASSWORD_ERROR unless /^(?=.*[a-zA-Z])(?=.*[0-9]).{7,}$/ =~ password
    end

    def validate_password_confirmation(password, password_confirmation)
      return PASSWORD_MISMATCH_ERROR if password != password_confirmation
    end

    def validate_name(name)
      return INVALID_NAME_ERROR if name.nil? || name.length < 5 || name.length > 20 || name =~ /\s/
    end
  end
end
