require 'sinatra'
require 'sinatra/activerecord'
require 'lib/model/user'

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
    erb :register, layout: false
  end
end
