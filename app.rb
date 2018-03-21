# frozen_string_literal: true

require 'bcrypt'
require 'lambda/helpers'
require 'lambda/lambda_manager'
require 'model/lambda'
require 'model/user'
require 'securerandom'
require 'sinatra'
require 'sinatra/activerecord'
require 'error_helpers'
require 'user/registration_validator'
require 'user/user_manager'
require 'lambda/creation_validator'
require 'json'

# Main class running the application and handling DSL routing.
class RunIt < Sinatra::Application # rubocop:disable Metrics/ClassLength
  register Sinatra::ActiveRecordExtension

  configure do
    set :public_folder, File.expand_path('../public', __FILE__)
    set :views, File.expand_path('../views', __FILE__)
    set :root, File.dirname(__FILE__)
    enable :sessions
    set :session_secret, 'Constant' || ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end

  THIRTY_DAYS_TO_SECONDS = 2_592_000

  get '/' do
    redirect '/login' unless login?
    erb :index,
        locals:
          {
            first_name: session[:first_name]
          }
  end

  get '/lambdas' do
    redirect '/login' unless login?

    erb :lambdas,
        locals:
        {
          first_name: session[:first_name],
          lambdas: lambda_manager.get_lambdas(session[:email]),
          errors: nil
        }
  end

  post '/lambdas' do
    redirect '/login' unless login?

    errors = lambda_manager.create_lambda(params, session[:user_id])
    {
      success: errors.empty?,
      errors: errors
    }.to_json
  end

  post '/lambdas/delete' do
    redirect '/login' unless login?

    errors = lambda_manager.delete_lambda(params['lambdaName'], session[:user_id])
    {
      success: errors.empty?,
      errors: errors
    }.to_json
  end

  get '/login' do
    redirect '/' if login?
    erb :login,
        layout: false,
        locals:
          {
            error: nil
          }
  end

  post '/login' do
    redirect '/' if login?
    error = user_manager.login(params)
    if error.nil?
      session[:email] = params[:email]
      user = Model::User.find_by(email: params[:email])
      session[:first_name] = user[:first_name]
      session[:user_id] = user[:id]
      session.options[:expire_after] = THIRTY_DAYS_TO_SECONDS unless params['remember_me'].nil?
      redirect '/'
    else
      erb :login,
          layout: false,
          locals:
            {
              error: error
            }
    end
  end

  get '/logout' do
    session[:email] = nil
    session[:first_name] = nil
    session[:user_id] = nil
    redirect '/'
  end

  get '/register' do
    redirect '/' if login?
    erb :register,
        layout: false,
        locals:
          {
            errors: nil
          }
  end

  post '/register' do
    redirect '/' if login?
    errors = user_manager.register(params)
    if errors.empty?
      session[:email] = params[:email]
      session[:first_name] = params[:firstName]
      session[:user_id] = user_manager.get_id(params[:email])
      redirect '/'
    end
    erb :register,
        layout: false,
        locals:
          {
            errors: errors
          }
  end

  private

  helpers do
    def login?
      !session[:email].nil?
    end
  end

  def user_manager
    @user_manager ||= User::UserManager.new(Model::User, BCrypt::Password, registration_validator)
  end

  def registration_validator
    @registration_validator ||= User::RegistrationValidator.new(Model::User)
  end

  def lambda_manager
    @lambda_manager ||= Lambda::LambdaManager
                        .new(
                          Model::Lambda,
                          Lambda::CreationValidator.new(Model::Lambda)
                        )
  end
end
