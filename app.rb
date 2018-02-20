require 'bcrypt'
require 'lib/model/user'
require 'lib/user_manager'
require 'sinatra'
require 'sinatra/activerecord'
require 'securerandom'

# Main class running the application and handling DSL routing.
class RunIt < Sinatra::Application
  register Sinatra::ActiveRecordExtension

  configure do
    set :public_folder, File.expand_path('../public', __FILE__)
    set :views, File.expand_path('../views', __FILE__)
    set :root, File.dirname(__FILE__)
    enable :sessions
    set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  end

  THIRTY_DAYS_TO_SECONDS = 2_592_000

  get '/' do
    redirect '/login' unless login?
    erb :index,
        locals:
          {
            user: session[:email]
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
            error: nil
          }
  end

  post '/register' do
    redirect '/' if login?
    error = user_manager.register(params)
    redirect '/login' unless error
    erb :register,
        layout: false,
        locals:
          {
            error: error
          }
  end

  private

  helpers do
    def login?
      !session[:email].nil?
    end
  end

  def user_manager
    @user_manager ||= UserManager.new(Model::User, BCrypt::Password)
  end
end
