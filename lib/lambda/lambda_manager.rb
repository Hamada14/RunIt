# frozen_string_literal: true

module Lambda
  # Manager class for the Lambda model which reads the data and display it.
  class LambdaManager
    attr_accessor :lambda_model, :creation_validator

    def initialize(lambda_model, creation_validator)
      @lambda_model = lambda_model
      @creation_validator = creation_validator
    end

    def create_lambda(params, user_id)
      errors = creation_validator.valid_params?(params, user_id)
      return errors unless errors.empty?
      lambda_model.create(
        name: params[:lambdaName],
        code: params[:lambdaCode],
        user_id: user_id
      )
      {}
    end

    def get_lambdas(email)
      lambda_model.joins(:user).where('users.email' => email)
    end
  end
end
