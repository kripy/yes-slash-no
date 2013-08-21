require "sinatra/base"
require "sinatra/assetpack"
require "compass"
require "compass-h5bp"
require "sinatra/support"
require "mustache/sinatra"
require "json"
require "httparty"
require "base64"

class App < Sinatra::Base
  base = File.dirname(__FILE__)
  set :root, base

  register Sinatra::AssetPack
  register Sinatra::CompassSupport
  register Mustache::Sinatra

  set :sass, Compass.sass_engine_options
  set :sass, { :load_paths => sass[:load_paths] + [ "#{base}/app/css" ] }

  assets do
    serve "/js",    from: "app/js"
    serve "/css",   from: "app/css"
    serve "/img",   from: "app/img"

    css :app_css, [ "/css/*.css" ]
    js :app_js, [
      "/js/*.js",
      "/js/vendor/jquery-1.9.1.min.js",
    ]
    js :app_js_modernizr, [ "/js/vendor/modernizr-2.6.2.min.js" ]
  end

  require "#{base}/app/helpers"
  require "#{base}/app/views/layout"

  set :mustache, {
    :templates => "#{base}/app/templates",
    :views => "#{base}/app/views",
    :namespace => App
  }

  before do
    @css = css :app_css
    @js  = js  :app_js
    @js_modernizr = js :app_js_modernizr
  end

  helpers do
    # Function allows both get / post.
    def self.get_or_post(path, opts={}, &block)
      get(path, opts, &block)
      post(path, opts, &block)
    end   

    # Makes the call to Heroku to get live answer.
    def get_answer()
      response = HTTParty.get("https://api.heroku.com/apps/" + ENV["YSN_APP_NAME"] + "/config-vars", 
        :headers => { "Accept" => "application/vnd.heroku+json; version=3",
          "Authorization" => ENV["YSN_APP_KEY"],
          "Content-Type" => "application/json"})
      parsed = JSON.parse(response.body)
      parsed["YSN_ANSWER"]
    end    
  end

  get "/" do
    @page_title = "Website Name"
    @answer = get_answer()

    mustache :index
  end

  # Switches between Yes / No. Handy when you're on the move.
  # Email the route to yourself and keep it handy.
  get "/" + ENV["YSN_ROUTE"] do
    answer = get_answer()

    if answer == "yes"
      response = HTTParty.patch("https://api.heroku.com/apps/" + ENV["YSN_APP_NAME"] + "/config-vars", 
        :body => { :YSN_ANSWER => "no" }.to_json, 
        :headers => { "Accept" => "application/vnd.heroku+json; version=3",
          "Authorization" => ENV["YSN_APP_KEY"],
          "Content-Type" => "application/json"})
      puts response
    else
      response = HTTParty.patch("https://api.heroku.com/apps/" + ENV["YSN_APP_NAME"] + "/config-vars",
        :body => { :YSN_ANSWER => "yes" }.to_json,
        :headers => { "Accept" => "application/vnd.heroku+json; version=3",
          "Authorization" => ENV["YSN_APP_KEY"],
          "Content-Type" => "application/json"})
      puts response
    end

    mustache :index
  end

  get "/try" do
    answer = get_answer()
    answer = answer["YSN_ANSWER"]
    puts answer

  end  
end