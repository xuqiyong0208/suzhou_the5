Encoding.default_internal='utf-8'
Encoding.default_external='utf-8'

require 'i18n'
I18n.enforce_available_locales = false

require File.expand_path('boot', __dir__)

require File.expand_path('settings', __dir__)

require File.expand_path('sinarey', __dir__)

requires = Dir[File.expand_path('initializers/*.rb', __dir__)]

['app/models','app/helpers','app/controllers','app/routes'].each do |path|
  requires += Dir[File.expand_path("../#{path}/*.rb", __dir__)].sort
end

requires.each do |file|
  require file
end

#p Category.db

require 'sinarey/router'
AppRouter = Sinarey::Router.new do
  mount StaticRoute
  mount StyleRoute
  mount BackendRoute
  notfound NotFoundRoute
end
