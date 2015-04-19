require 'yaml'
require 'logger'

module Sinarey

  @root = File.expand_path('..', __dir__)
  @env = ENV['RACK_ENV'] || 'development'

  dbyml = YAML::load(File.open(@root+'/config/database.yml'))
  @dbconfig = dbyml["database"]
  
  class << self
    attr_reader :root
    attr_accessor :env,:dbconfig
  end
  
end


require 'bundler'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup'

