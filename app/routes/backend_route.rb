
class BackendRoute < BackendController

  error do halt_500 end

  route :get,   '/admin'                do dispatch(:index_page) end

  route :post,  '/admin'                do dispatch(:login_action) end

  route :get,   '/admin/logout'         do dispatch(:logout_action) end

  route :get,   '/admin/intro'          do dispatch(:intro_page) end

  route :post,  '/admin/intro'          do dispatch(:do_update_intro) end

  route :get,   '/admin/contact'        do dispatch(:contact_page) end

  route :post,  '/admin/contact'        do dispatch(:do_update_contact) end



  route :get,   '/admin/video'         do dispatch(:video_page) end

  route :get,   '/admin/new_video'     do dispatch(:new_video_page) end

  route :post,  '/admin/create_video'  do dispatch(:do_create_video) end

  route :get,   '/admin/show_video/:id'  do dispatch(:single_video_page) end

  route :get,   '/admin/edit_video/:id' do dispatch(:edit_video_page) end

  route :post,  '/admin/update_video'  do dispatch(:do_update_video) end

  route :post,  '/admin/destroy_video' do dispatch(:do_destroy_video) end

  route :get,   '/admin/hot_video'     do dispatch(:hot_video_page) end

  route :post,  '/admin/hot_video'     do dispatch(:update_hot_video) end



  route :get,   '/admin/banner'         do dispatch(:banner_page) end

  route :get,   '/admin/new_banner'     do dispatch(:new_banner_page) end

  route :post,  '/admin/create_banner'  do dispatch(:do_create_banner) end

  route :get,   '/admin/edit_banner/:id' do dispatch(:edit_banner_page) end

  route :post,  '/admin/update_banner'  do dispatch(:do_update_banner) end

  route :post,  '/admin/destroy_banner' do dispatch(:do_destroy_banner) end

  route :get,   '/admin/hot_banner'     do dispatch(:hot_banner_page) end

  route :post,  '/admin/hot_banner'     do dispatch(:update_hot_banner) end



  route :get,   '/admin/production'       do dispatch(:production_page) end

  route :get,   '/admin/new_production'   do dispatch(:new_production_page) end

  route :post,  '/admin/create_production' do dispatch(:do_create_production) end

  route :get,   '/admin/edit_production/:id' do dispatch(:edit_production_page) end

  route :post,  '/admin/update_production' do dispatch(:do_update_production) end

  route :get,   '/admin/edit_production_cover/:id' do dispatch(:edit_production_cover_page) end

  route :post,  '/admin/update_production_cover' do dispatch(:do_update_production_cover) end

  route :post,  '/admin/do_destroy_production' do dispatch(:do_destroy_production) end

  route :get,   '/admin/hot_production' do dispatch(:hot_production_page) end

  route :post,  '/admin/hot_production' do dispatch(:update_hot_production) end



  route :get,   '/admin/category'       do dispatch(:category_page) end

  route :get,   '/admin/new_category'       do dispatch(:new_category_page) end

  route :post,   '/admin/create_category'       do dispatch(:do_create_category) end

  route :get,   '/admin/edit_category/:id'   do dispatch(:edit_category_page) end

  route :post,  '/admin/update_category' do dispatch(:do_update_category) end

  route :get,   '/admin/edit_category_logo/:id' do dispatch(:edit_category_logo_page) end

  route :post,  '/admin/update_category_logo' do dispatch(:do_update_category_logo) end

  route :post,  '/admin/destroy_category' do dispatch(:do_destroy_category) end



  route :get,   '/admin/base'             do dispatch(:base_page) end

  route :get,   '/admin/new_base'         do dispatch(:new_base_page) end  

  route :post,   '/admin/create_base'     do dispatch(:do_create_base) end    

  route :get,   '/admin/edit_base/:id'    do dispatch(:edit_base_page) end

  route :post,  '/admin/update_base'      do dispatch(:do_update_base) end

  route :get,   '/admin/edit_base_cover/:id'  do dispatch(:edit_base_cover_page) end

  route :post,  '/admin/update_base_cover' do dispatch(:do_update_base_cover) end

  route :post,  '/admin/destroy_base'     do dispatch(:do_destroy_base) end

  route :get,   '/admin/hot_base'         do dispatch(:hot_base_page) end

  route :post,  '/admin/hot_base'         do dispatch(:update_hot_base) end



  route :get,   '/admin/edit_password'        do dispatch(:edit_password_page) end

  route :post,  '/admin/update_password'      do dispatch(:do_update_password) end


  route :get,   '/admin/error_page'       do dispatch(:error_page) end

  route :get,:post, '/ueditor/server_url'  do

    case params[:action]
    when "config"
    opts = {
        imageUrlPrefix: "",
        imagePath: static_url(""),
        imageFieldName: "upfile",
        imageMaxSize: 10240,
        imageAllowFiles: [".png", ".jpg", ".jpeg"],
        imageActionName: "simpleupload"
    }
    halt_json(opts)
    when "simpleupload"

      upfile = params[:upfile]
      halt_500 if upfile.nil? or upfile.class != Hash

      model = UeditorFile.new
      model.cover_path = upfile
      halt_500 if !model.save

      cover = model.cover_path

      result = {
        original: cover.filename,
        name: cover.filename,
        url: cover.url,
        size: cover.size,
        type: ".#{cover.file.extension}",
        state: "SUCCESS"
      }
      halt_json(result)
    when nil
      "action is underfined"
    else
      "unknown action #{params[:action]}"
    end
  end

end
