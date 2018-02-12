require 'sinatra'

class RunIt < Sinatra::Application
  configure do
    set :public_folder, File.expand_path('../public', __FILE__)
    set :views, File.expand_path('../views', __FILE__)
    set :root, File.dirname(__FILE__)
  end

  get '/' do
    "Hello world"
  end

  get '/home' do
    erb :index
  end

  get '/sign-in' do
    erb :sign_in, layout: false
  end

end
