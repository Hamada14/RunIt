require 'bcrypt'
require 'lib/model/user'
require 'lib/user_registeration'
require 'sinatra'
require 'sinatra/activerecord'

# Main class running the application and handling DSL routing.
class RunIt < Sinatra::Application
  register Sinatra::ActiveRecordExtension

  configure do
    set :public_folder, File.expand_path('../public', __FILE__)
    set :views, File.expand_path('../views', __FILE__)
    set :root, File.dirname(__FILE__)
  end

  get '/' do
  end

  get '/home' do
    erb :index
  end

  get '/sign-in' do
    erb :sign_in, layout: false
  end

  get '/register' do
    erb :register,
        layout: false,
        locals:
          {
            error: nil
          }
  end

  post '/register' do
    error = user_registration.register(params)
    redirect '/sign-in' unless error
    erb :register,
        layout: false,
        locals:
          {
            error: error
          }
  end

  private

  def user_registration
    @user_registration ||= UserRegistration.new(Model::User, BCrypt::Password)
  end
end
