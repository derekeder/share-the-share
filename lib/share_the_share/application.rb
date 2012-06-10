require "sinatra/base"
require "sinatra/reloader"
require "sinatra-initializers"
require "sinatra/r18n"

module ShareTheShare
  class Application < Sinatra::Base
    enable :logging, :sessions
    enable :dump_errors, :show_exceptions if development?

    configure :development do
      register Sinatra::Reloader
    end

    configure do   
      begin
        yaml = YAML.load_file("config/config.yaml")[settings.environment.to_s]
        yaml.each_pair do |key, value|
          set(key.to_sym, value)
        end
      rescue Errno::ENOENT
        puts "config file not found"
      end
    end

    register Sinatra::Initializers
    register Sinatra::R18n

    before do
      session[:locale] = params[:locale] if params[:locale]
    end

    use Rack::Logger
    use Rack::Session::Cookie

    helpers ShareTheShare::HtmlHelpers

    post '/send' do
      
      #get form variables
      post = params[:post]
      name = post[:name]
      body << "Thanks for sharing your share!\n\n"
      body << "Your info:\n"
      
      post.each_pair do |k,v|
        body << "#{k}: #{v}\n"
      end
      
      #send email to submitter
      send_email "derek.eder@gmail.com", "share.the.share.info.@gmail.com", "Thanks for sharing your share!", body
      
      #send notify email to admin
      send_email "derek.eder@gmail.com", "share.the.share.info.@gmail.com", "#{name} has shared their share", body
      
      haml :thanks
    end

    get "/" do
      response.headers["X-Frame-Options"] = 'GOFORIT'
      haml :index
    end
    
    get "/:page" do
      @current_menu = params[:page]
      haml params[:page].to_sym
    end
  end
end
