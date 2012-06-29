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
      
      if (params[:post] != '' && params[:post][:name] != '' && params[:post][:email] != '')
        #get form variables
        post = params[:post]
        name = post[:Name]
        userbody = "Thanks for sharing your share!\n\n"
        userbody << "We have received your information and we'll make sure a family in need receives your share. If you have any questions or your information below is incorrect, feel free to contact us at share.the.share.info@gmail.com.\n\n"
        userbody << "Your info:\n"
        
        adminbody = "Submitter details:\n"
        
        post.each_pair do |k,v|
          userbody << "#{k}: #{v}\n"
          adminbody << "#{k}: #{v}\n"
        end
        
        userbody << "\nVisit us at http://sharemyshare.org to share your share again!"
        
        #send email to submitter
        send_email post[:Email], "share.the.share.info@gmail.com", "Thanks for sharing your share!", userbody
        
        #send notify email to admin
        send_email "share.the.share.info@gmail.com", "share.the.share.info@gmail.com", "#{name} has shared their share", adminbody
        
        haml :thanks
      else
        haml :error
      end
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
