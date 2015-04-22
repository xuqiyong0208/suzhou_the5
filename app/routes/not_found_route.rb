
class NotFoundRoute < ApplicationController

  error do halt_500 end

  not_found do
    halt_404
  end

end
