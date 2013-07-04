require "sinatra/base"
require "sinatra/assetpack"
require "compass"
require "compass-h5bp"
require "sinatra/support"
require "mustache/sinatra"
require "json"

class App < Sinatra::Base
  base = File.dirname(__FILE__)
  set :root, base

  app_json = "#{base}/app/result.json"

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

  # Function allows both get / post.
  def self.get_or_post(path, opts={}, &block)
    get(path, opts, &block)
    post(path, opts, &block)
  end

  get "/" do
    @page_title = "Website Name"
    answer = JSON.parse(File.open(app_json).read)
    @answer = answer["answer"]

    mustache :index
  end

  # Switches between Yes / No. Handy when you're on the move.
  # Email the route to yourself and keep it handy.
  # Variable store in .env file.
  get "/" + ENV['YSN_ROUTE'] do
    answer = JSON.parse(File.open(app_json).read)
    answer = answer["answer"]

    if answer == "yes"
      File.open(File.open(app_json), 'w') { |file| file.write("{\"answer\": \"no\"}") }
    else
      File.open(File.open(app_json), 'w') { |file| file.write("{\"answer\": \"yes\"}") }
    end
    redirect '/'
  end
end
