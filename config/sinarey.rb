
require 'sinarey'

require "sinatra/multi_route"
require "sinatra/content_for"
require "sinatra/cookies"

require 'sinarey_support'
require 'erb_safe_ext'

require 'sequel'
require 'will_paginate'
require 'timerizer'
require 'oj'


db_logger = {logger: nil && Logger.new(STDOUT)}
db_opts = Sinarey.dbconfig.merge(db_logger)

p db_opts

DB = Sequel.connect(db_opts)

DB.extension(:pagination)
Sequel::Model.plugin :timestamps, update_on_create:true

module Sinarey

  class Application < Sinatra::SinareyBase

    set :default_encoding, 'utf-8'

    helpers Sinatra::ContentFor

    register WillPaginate::Sinatra
    register Sinatra::MultiRoute

    helpers Sinatra::Cookies
    set :cookie_options, {path:'/',expires:1.year.from_now,httponly:false}

    set :static, false

    #logger configure
    set :logging, nil

    set :erb, trim: '>'

    set :raise_errors, false
    set :dump_errors, false

    case Sinarey.env
    when 'production'
      set :show_exceptions, false
    else
      require "sinatra/sinarey_reloader"
      register Sinatra::SinareyReloader
      Dir["#{Sinarey.root}/app/*/*.rb"].each {|f| also_reload f }
      set :show_exceptions, true
    end

    #use custom logic for finding template files
    def find_template(views, name, engine, &block)
      paths = views.map { |d| Sinarey.root + '/app/views/' + d }
      Array(paths).each { |v| super(v, name, engine, &block) }
    end

    def access_logger
      current_day = Time.now.strftime('%Y-%m-%d')
      if (@@access_logger_day||=nil) != current_day
        @@access_logger = ::Logger.new(Sinarey.root+"/log/#{current_day}_access.log")
        @@access_logger_day = current_day
      end
      @@access_logger
    end

    def accesslog(msg)
      access_logger << (msg.to_s + "\n")
    end



    helpers do

      def escape_javascript(javascript)
        if javascript
          javascript.gsub(/(\\|<\/|\r\n|\342\200\250|\342\200\251|[\n\r"'])/u) {|match| JS_ESCAPE_MAP[match] }
        else
          ''
        end
      end

      def app_logger
        current_day = Time.now.strftime('%Y-%m-%d')
        if (@@app_logger_day||=nil) != current_day
          @@app_logger = ::Logger.new(Sinarey.root+"/log/#{current_day}_app.log")
          @@app_logger_day = current_day
        end
        @@app_logger
      end

      def dump_errors
        boom = env['sinatra.error']
        if boom.present?
          msg = ["#{boom.class} - #{boom.message}:", *boom.backtrace].join("\n\t")
          puts(msg)
        end
      end

      #覆写 p方法 和 puts方法 !!!

      def p(msg)
        app_logger << (msg.inspect + "\n")
      end

      def puts(msg)
        app_logger << (msg.to_s + "\n")
      end
      
    end
    

    #开发环境，日志转到STDOUT
    if Sinarey.env=='development'

      def access_logger
        Logger.new(STDOUT) 
      end

      helpers do 
        def app_logger 
          Logger.new(STDOUT) 
        end
      end
    end

  end
end

JS_ESCAPE_MAP = {
  '\\'    => '\\\\',
  '</'    => '<\/',
  "\r\n"  => '\n',
  "\n"    => '\n',
  "\r"    => '\n',
  '"'     => '\\"',
  "'"     => "\\'"
}

JS_ESCAPE_MAP["\342\200\250".force_encoding(Encoding::UTF_8).encode!] = '&#x2028;'
JS_ESCAPE_MAP["\342\200\251".force_encoding(Encoding::UTF_8).encode!] = '&#x2029;'

class ApplicationController < Sinarey::Application ; end #init