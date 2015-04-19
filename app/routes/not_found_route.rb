
class NotFoundRoute < ApplicationController

  not_found do
    halt_404
  end

end
