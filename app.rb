require 'bcrypt'
require 'model/user'
require 'securerandom'
require 'sinatra'
require 'sinatra/activerecord'
require 'user/registration_validator'
require 'user/user_manager'
require 'user/error_helpers'

# Main class running the application and handling DSL routing.
class RunIt < Sinatra::Application
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
        }
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
      session[:first_name] = Model::User.find_by(email: params[:email])[:first_name]
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
      session[:firstName] = params[:first_name]
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
end
