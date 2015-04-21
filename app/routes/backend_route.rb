
class BackendRoute < BackendController

  error do halt_500 end

  route :get,   '/admin'                do dispatch(:index_page) end

  route :post,  '/admin'                do dispatch(:login_action) end

  route :get,   '/admin/logout'         do dispatch(:logout_action) end

  route :get,   '/admin/intro'          do dispatch(:intro_page) end

  route :post,  '/admin/intro'          do dispatch(:do_update_intro) end

  route :get,   '/admin/contact'        do dispatch(:contact_page) end

  route :post,  '/admin/contact'        do dispatch(:do_update_contact) end

  route :get,   '/admin/production'       do dispatch(:production_page) end

  route :get,   '/admin/edit_production/:id' do dispatch(:edit_production_page) end

  route :post,  '/admin/update_production' do dispatch(:do_update_production) end

  route :get,   '/admin/edit_production_cover/:id' do dispatch(:edit_production_cover_page) end

  route :post,  '/admin/update_production_cover' do dispatch(:do_update_production_cover) end

  route :get,   '/admin/category'       do dispatch(:category_page) end

  route :get,   '/admin/edit_category/:id'   do dispatch(:edit_category_page) end

  route :post,  '/admin/update_category' do dispatch(:do_update_category) end

  route :get,   '/admin/edit_category_logo/:id' do dispatch(:edit_category_logo_page) end

  route :post,  '/admin/update_category_logo' do dispatch(:do_update_category_logo) end



  route :get,   '/ueditor/server_url' do

    case params[:action]
    when "config"
    opts = {
        imageUrl: "/ueditor/php/controller.php?action=uploadimage",
        imagePath: static_url(""),
        imageFieldName: "upfile",
        imageMaxSize: 2048,
        imageAllowFiles: [".png", ".jpg", ".jpeg", ".gif", ".bmp"],
        imageActionName: "simpleupload"
    }
    halt_json(opts)
    when "simpleupload"
      "TODO simpleupload"
    when nil
      "action is underfined"
    else
      "unknown action #{params[:action]}"
    end
  end

end
