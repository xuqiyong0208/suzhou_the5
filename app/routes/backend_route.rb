
class BackendRoute < BackendController

  error do halt_500 end

  route :get,   '/admin'                do dispatch(:index_page) end

  route :post,  '/admin'                do dispatch(:login_action) end

  route :get,   '/admin/logout'         do dispatch(:logout_action) end

  route :get,   '/admin/intro'          do dispatch(:intro_page) end

  route :post,  '/admin/intro'          do dispatch(:do_update_intro) end

  route :get,   '/admin/contact'        do dispatch(:contact_page) end

  route :post,  '/admin/contact'        do dispatch(:do_update_contact) end

  route :get,   '/admin/category'       do dispatch(:category_page) end

  route :get,   '/admin/category/:name' do dispatch(:edit_category_description_page) end

  route :post,  '/admin/update_category_description' do dispatch(:do_update_category_description) end

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
