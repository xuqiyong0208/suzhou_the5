
class StyleRoute < StyleController

  error do halt_500 end

  route :get, '/'                   do dispatch(:index_page) end

  route :get, '/production'         do dispatch(:production_page) end

  route :get, '/production/:name'   do dispatch(:single_production_page)  end

  route :get, '/about'              do dispatch(:about_page) end

  route :get, '/contact'            do dispatch(:contact_page) end

end
