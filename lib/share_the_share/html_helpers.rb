module ShareTheShare
  module HtmlHelpers
    def include_stylesheet name, options={}
      href = "/stylesheets/#{name}.css" unless name.to_s.match(/^http/)
      content_tag :link, nil, options.merge(:rel => "stylesheet", :href => (href || name))
    end

    def include_favicon name, options={}
      href = "/#{name}.ico" unless name.to_s.match(/^http/)
      content_tag :link, nil, options.merge(:rel => "shortcut icon", :href => (href || name))
    end

    def include_javascript name, options={}
      href = "/javascripts/#{name}.js" unless name.to_s.match(/^http/)
      content_tag :script, "", :type => "text/javascript", :src => (href || name)
    end

    def include_mustache name, options={}
      href = "/mustaches/#{name}.mustache" unless name.to_s.match(/^http/)
      content_tag :script, "", :type => "text/javascript", :src => (href || name)
    end

    def image_tag name, options={}
      src = "/images/#{name}" unless name.to_s.match(/^http/)
      content_tag :img, nil, options.merge(:alt => name, :src => (src || name))
    end

    # TODO: correct to include link text
    def link_to name, href, options={}
      content_tag :a, name, options.merge(:href => href)
    end

    def content(section, *args)
      view_content[section.to_sym].map! do |content|
        if respond_to?(:block_is_haml?) && block_is_haml?(content)
          capture_haml(*args, &content)
        else
          content
        end
      end.join if view_content[section.to_sym]
    end

    def content_for(section, &block)
      view_content[section.to_sym] << block
    end

    def view_content
      @view_content ||= Hash.new{|h,k| h[k]=[]}
    end

    def content_tag tag, value, options={}
      element = "<#{tag}"
      options.each do |name, value|
        element << " #{name}=\"#{value}\""
      end

      if value.nil?
        element << "/>"
      else
        element << ">"
        element << (block_given? ? yield : value)
        element << "</#{tag}>"
      end

      element
    end
    
    def send_email to, from, subject, body
      begin
        gmail_account = settings.gmail_account.to_s
        gmail_password = settings.gmail_password.to_s
      rescue
        gmail_account = ENV['gmail_account']
        gmail_password = ENV['gmail_password'] 
      end
      
      Pony.mail(:to => to, 
              :from => from, 
              :subject=> subject,
              :body => body,
              :via => :smtp, :smtp => {
                      :host       => 'smtp.gmail.com',
                      :port       => '587',
                      :user       => gmail_account,
                      :password   => gmail_password,
                      :auth       => :plain,
                      :domain     => "sharetheshare.org"
              }
        )
    
    end
    
  end
end
