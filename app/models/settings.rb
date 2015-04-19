
require 'settingslogic'

class Settings < Settingslogic
  
  if ENV['SINAREY_ENV'] == 'heroku'
    source "#{Sinarey.root}/config/heroku/settings.yml"
  else
    source "#{Sinarey.root}/config/settings.yml"
  end

  load!
end