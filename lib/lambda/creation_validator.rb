# frozen_string_literal: true

module Lambda
  # Validator for the creation of Lambda which makes sure that the data follows the required
  # specifications.
  class CreationValidator
    attr_accessor :lambda_model

    INVALID_LAMBDA_NAME_ERROR = 'Invalid Lambda name format'
    DUPLICATE_LAMBDA_NAME_ERROR = 'Duplicate Lambda name'

    def initialize(lambda_model)
      @lambda_model = lambda_model
    end

    def valid_params?(params, user_id)
      {
        lambdaName: validate_lambda_pattern(params[:lambdaName]) ||
          validate_unique_name(params[:lambdaName], user_id)
      }.delete_if { |_, v| v.nil? }
    end

    private

    def validate_lambda_pattern(lambda_name)
      return INVALID_LAMBDA_NAME_ERROR if (/[a-zA-Z][a-zA-Z0-9]{7,20}/ =~ lambda_name) != 0
    end

    def validate_unique_name(lambda_name, user_id)
      return nil if lambda_model
                    .joins(:user)
                    .find_by('users.id' => user_id, 'lambdas.name' => lambda_name).nil?
      DUPLICATE_LAMBDA_NAME_ERROR
    end
  end
end
