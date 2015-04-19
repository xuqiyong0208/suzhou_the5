
require 'settingslogic'

class Settings < Settingslogic
  
  source "#{Sinarey.root}/config/settings.yml"

  load!
end