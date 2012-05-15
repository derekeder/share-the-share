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

    get '/send' do
      
      begin
        gmail_account = settings.gmail_account.to_s
        gmail_password = settings.gmail_password.to_s
      rescue
        gmail_account = ENV['gmail_account']
        gmail_password = ENV['gmail_password'] 
      end

      Pony.mail(:to=>"derek.eder@gmail.com", 
              :from => 'share.the.share.info.@gmail.com', 
              :subject=> "test message!",
              :body => "Thanks for sharing your share!",
              :via => :smtp, :smtp => {
                      :host       => 'smtp.gmail.com',
                      :port       => '587',
                      :user       => settings.gmail_account.to_s,
                      :password   => settings.gmail_password.to_s,
                      :auth       => :plain,
                      :domain     => "sharetheshare.org"
              }
        )
        "Email sent!"
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
