
class BackendRoute < BackendController

  error do halt_500 end

  route :get,   '/admin'              do dispatch(:index_page) end

  route :post,  '/admin'              do dispatch(:login_action) end

  route :get,   '/admin/logout'       do dispatch(:logout_action) end

end
