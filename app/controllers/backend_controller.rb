
class BackendController < ApplicationController

  before do
    set_current_admin
    require_admin_filter if request.path_info != "/admin"
  end

  set :views, ['backend','application']

  def dispatch(action,options={})
    super(BackendController,action)
    method(action).call
  end

  #出错提示页
  def error_page
    halt_error(flash[:error])
  end

  def redirect_to_error_page(msg=nil)
    if msg.present?
      flash[:error] = msg.to_s
    end 
    redirect_to "/admin/error_page"
  end

  #获取当前管理员信息
  def set_current_admin

    token = cookies[:token]
    uid,secrue = token.to_s.split('|')

    return if uid.blank? or secrue.blank?

    client_ip = get_client_ip
    return if client_ip.blank?

    uid = uid.to_i
    user = Admin.where(id: uid).first
    return if user.nil?

    return if Admin.generate_secrue(user,client_ip) != secrue

    @admin = user
  end

  #如果获取不到管理员信息，跳转到登录页
  def require_admin_filter
    return if @admin

    tmp = "/admin"
    to_url = request.get? ? request.fullpath : nil
    tmp += "?to_url=#{CGI.escape(to_url)}" if to_url.present?
    redirect_to tmp
  end

  #后台首页
  def index_page
    login_page if !@admin
    
    halt_page(:index_page)
  end

  #公司介绍管理页
  def intro_page

    record = Meta.where(name: 'intro', page: 1).first
    @content = record.content if record

    halt_page(:intro_page)
  end

  #修改公司介绍
  def do_update_intro
    content = params[:content].to_s
    record = Meta.where(name: 'intro', page: 1).first
    if record
      record.update(content:content)
    else
      Meta.create(content:content, name: 'intro')
    end
    halt_json(res: true)
  end

  #联系我们管理页
  def contact_page
    record = Meta.where(name: 'contact', page: 1).first
    @content = record.content if record
    halt_page(:contact_page)
  end

  #修改联系我们
  def do_update_contact
    content = params[:content].to_s
    record = Meta.where(name: 'contact', page: 1).first
    if record
      record.update(content:content)
    else
      Meta.create(content:content, name: 'contact')
    end
    halt_json(res: true)
  end





  #产品管理页面
  def production_page
    all_categories = get_all_categories

    @category_dict = {}
    @productions = []

    children_exist = {}
    all_categories.each do |category|
      father = category.father
      if father.present?
        children_exist[father] ||= true
      else
        @category_dict[category.id] ||= category.title
      end
    end

    all_categories.each do |category|
      next if category.father.nil? and children_exist[category.id]
      @productions << category
    end

    halt_page(:production_page)
  end

  #新建产品表单页
  def new_production_page

    @categories = Category.where(father: nil).all

    halt_page(:new_production_page)
  end

  #创建产品
  def do_create_production

    name, title, intro = params[:name].to_s, params[:title].to_s, params[:intro].to_s
    halt_json(res:false, msg: "请输入产品ID") if name.blank?

    halt_json(res:false, msg: "产品ID格式不正确，仅支持英文字母、数字以及下划线") if !name_regex_match?(name)

    halt_json(res:false, msg: "请输入产品名称") if title.blank?

    father = (tmp=params[:father].to_i)>0 ? tmp : nil

    production = Category.new
    production.name = name
    production.title = title
    production.intro = intro[0,191]
    production.father = father
    production.save

    content = params[:content].to_s
    description = CategoryDescription.where(category_id: production.id).first
    if description
      description.update(content:content)
    else
      CategoryDescription.create(content:content, category_id: production.id)
    end

    halt_json(res:true)
  end

  #编辑产品信息表单页
  def edit_production_page

    @production = get_production_by_id(params[:id])
    halt_404 if @production.nil?

    record = CategoryDescription.where(category_id: @production.id).first
    @content = record && record.content

    @categories = Category.where(father: nil).all

    halt_page(:edit_production_page)
  end

  #更新产品信息
  def do_update_production

    production = get_production_by_id(params[:id])
    halt_json(res:false, msg: "指定产品不存在") if production.nil?

    name, title, intro = params[:name].to_s, params[:title].to_s, params[:intro].to_s
    halt_json(res:false, msg: "请输入产品ID") if name.blank?

    halt_json(res:false, msg: "产品ID格式不正确，仅支持英文字母、数字以及下划线") if !name_regex_match?(name)

    halt_json(res:false, msg: "请输入产品名称") if title.blank?

    father = (tmp=params[:father].to_i)>0 ? tmp : nil

    production.name = name
    production.title = title
    production.intro = intro[0,191]
    production.father = father
    production.save

    content = params[:content].to_s
    description = CategoryDescription.where(category_id: production.id).first
    if description
      description.update(content:content)
    else
      CategoryDescription.create(content:content, category_id: production.id)
    end
    halt_json(res:true)
  end

  #编辑产品图片表单页
  def edit_production_cover_page

    @production = get_production_by_id(params[:id])
    halt_404 if @production.nil?

    halt_page(:edit_production_cover_page)
  end

  #更新产品图片
  def do_update_production_cover
    @production = get_production_by_id(params[:id])
    redirect_to_error_page "抱歉，你选择的产品不存在或者已被删除" if !@production
    cover_path = params[:cover_path]
    redirect_to_error_page "抱歉，更新产品图片失败" if cover_path.nil? or cover_path.class != Hash

    @production.cover_path = cover_path
    if !@production.save
      redirect_to_error_page
    end
    redirect_to request.referer || "/admin"
  end

  #删除产品
  def do_destroy_production

    @production = get_production_by_id(params[:id])
    @production.destroy if @production
    halt_json(res:true)
  end

  #配置热销产品表单页
  def hot_production_page

    all_categories = get_all_categories

    @category_dict = {}
    @productions = {}
    @pids = {}

    children_exist = {}
    all_categories.each do |category|
      father = category.father
      if father.present?
        children_exist[father] ||= true
      else
        @category_dict[category.id] ||= category.title
      end
    end

    all_categories.each do |category|
      next if category.father.nil? and children_exist[category.id]
      @productions[category.id] = category
    end

    hot = Meta.where(name: 'hot_production', page: 1).first
    if hot
      ids = hot.content.to_s.split(",")
      ids.each do |num|
        num = num.to_i
        next if num<=0 or @productions[num].nil?
        @pids[num] = num
      end
    end

    halt_page(:hot_production_page)
  end

  #更新热销产品
  def update_hot_production

    ids_str = params[:ids].to_s
    ids_arr = ids_str.split(",")

    genenrate_ids_arr = [] 

    ids_arr.each do |pid|
      pid = pid.to_i
      next if pid <= 0
      production = get_production_by_id(pid)
      if production
        genenrate_ids_arr << production.id
      end
    end

    hot = Meta.where(name: 'hot_production', page: 1).first

    max_size = 10
    if hot
      current_ids_arr = hot.content.to_s.split(",")
    else
      current_ids_arr = []
    end
    if current_ids_arr.length > max_size
      genenrate_ids_arr = current_ids_arr.first(max_size) #先恢复成允许的最大值
    else
      if genenrate_ids_arr.length > max_size
        halt_json(res: false, msg: "抱歉，热销商品数量不能超过#{max_size}个")
      end
    end

    genenrate_ids_str =genenrate_ids_arr.uniq.join(",")

    if hot
      hot.update(content: genenrate_ids_str)
    else
      Meta.create(content: genenrate_ids_str, name: 'hot_production')
    end

    halt_json(res: true)
  end





  #产品海报管理页
  def banner_page

    banners = Banner.reverse_order(:id).all

    pids = banners.map(&:production_id)

    product_dict = {}
    productions = Category.where(id: pids).all
    productions.each do |product|
      product_dict[product.id] = product
    end

    @banner_dict = {}
    banners.each do |banner|
      @banner_dict[banner.id] = {cover_url: banner.cover_path.url, production: product_dict[banner.production_id]}
    end

    halt_page(:banner_page)
  end

  #新建产品海报表单页
  def new_banner_page

    all_categories = get_all_categories

    @category_dict = {}
    @productions = []

    children_exist = {}
    all_categories.each do |category|
      father = category.father
      if father.present?
        children_exist[father] ||= true
      else
        @category_dict[category.id] ||= category.title
      end
    end

    all_categories.each do |category|
      next if category.father.nil? and children_exist[category.id]
      @productions << category
    end

    halt_page(:new_banner_page)
  end

  #创建产品海报
  def do_create_banner

    production = get_production_by_id(params[:production_id])
    redirect_to_error_page "抱歉，您选择的产品不存在或者已被删除" if production.nil?

    cover_path = params[:cover_path]
    redirect_to_error_page "抱歉，上传产品海报失败" if cover_path.nil? or cover_path.class != Hash

    banner = Banner.new
    banner.production_id = production.id
    banner.cover_path = cover_path
    if !banner.save
      redirect_to_error_page
    end

    redirect_to "/admin/edit_banner/#{banner.id}"
  end

  #编辑产品海报表单页
  def edit_banner_page

    banner_id = params[:id].to_i
    halt_404 if banner_id <= 0

    @banner = Banner.where(id:banner_id).first
    halt_404 if @banner.nil?

    all_categories = get_all_categories

    @category_dict = {}
    @productions = []

    children_exist = {}
    all_categories.each do |category|
      father = category.father
      if father.present?
        children_exist[father] ||= true
      else
        @category_dict[category.id] ||= category.title
      end
      @production = category if @banner.production_id == category.id
    end

    all_categories.each do |category|
      next if category.father.nil? and children_exist[category.id]
      @productions << category
    end

    halt_page(:edit_banner_page)
  end

  #更新产品海报
  def do_update_banner

    banner_id = params[:id].to_i

    @banner = Banner.where(id:banner_id).first
    redirect_to_error_page "抱歉，你选择的产品海报不存在或者已被删除" if @banner.nil?

    production = get_production_by_id(params[:production_id])
    redirect_to_error_page "抱歉，您选择的产品不存在或者已被删除" if production.nil?

    cover_path = params[:cover_path]
    if cover_path and cover_path.class == Hash
      @banner.cover_path = cover_path
    end

    @banner.production_id = production.id

    if !@banner.save
      redirect_to_error_page
    end
    redirect_to request.referer || "/admin"
  end

  #删除产品海报
  def do_destroy_banner
    banner_id = params[:id].to_i
    halt_json(res:true) if banner_id <= 0

    @banner = Banner.where(id:banner_id).first
    @banner.destroy if @banner
    halt_json(res:true)
  end

  #产品海报管理页
  def hot_banner_page

    banners = Banner.reverse_order(:id).all

    pids = banners.map(&:production_id)

    product_dict = {}
    productions = Category.where(id: pids).all
    productions.each do |product|
      product_dict[product.id] = product
    end

    @banner_dict = {}
    banners.each do |banner|
      @banner_dict[banner.id] = {cover_url: banner.cover_path.url, production: product_dict[banner.production_id]}
    end

    @pids ={}
    hot = Meta.where(name: 'hot_banner', page: 1).first
    if hot
      ids = hot.content.to_s.split(",")
      ids.each do |num|
        num = num.to_i
        next if num<=0 or @banner_dict[num].nil?
        @pids[num] = num
      end
    end

    halt_page(:hot_banner_page)
  end

  #更新当前海报
  def update_hot_banner

    ids_str = params[:ids].to_s
    ids_arr = ids_str.split(",")

    genenrate_ids_arr = [] 

    ids_arr.each do |pid|
      pid = pid.to_i
      next if pid <= 0
      banner = Banner.where(id:pid).first
      if banner
        genenrate_ids_arr << banner.id
      end
    end

    hot = Meta.where(name: 'hot_banner', page: 1).first

    max_size = 6
    if hot
      current_ids_arr = hot.content.to_s.split(",")
      if current_ids_arr.length > max_size
        need_repair = true
      end
    end

    if need_repair
      genenrate_ids_arr = genenrate_ids_arr.first(max_size)
    elsif genenrate_ids_arr.length > max_size
      halt_json(res: false, msg: "抱歉，当前海报数量不能超过#{max_size}个")
    end

    genenrate_ids_str =genenrate_ids_arr.uniq.join(",")

    if hot
      hot.update(content: genenrate_ids_str)
    else
      Meta.create(content: genenrate_ids_str, name: 'hot_banner')
    end
    halt_json(res:true)
  end




  #视频管理页
  def video_page

    @videos = Video.reverse_order(:id).all

    halt_page(:video_page)
  end

  #新建视频表单页
  def new_video_page

    halt_page(:new_video_page)
  end

  #创建视频
  def do_create_video

    title = params[:title].to_s
    halt_json(res:false, msg: "请输入视频名称") if title.blank?

    video_path = params[:video_path]
    redirect_to_error_page "抱歉，上传视频失败" if video_path.nil? or video_path.class != Hash

    video = Video.new

    video.title = title
    video.video_path = video_path
    if !video.save
      redirect_to_error_page
    end

    redirect_to "/admin/edit_video/#{video.id}"
  end

  #编辑视频表单页
  def edit_video_page

    video_id = params[:id].to_i
    halt_404 if video_id <= 0

    @video = Video.where(id:video_id).first
    halt_404 if @video.nil?

    halt_page(:edit_video_page)
  end

  #更新视频
  def do_update_video

    video_id = params[:id].to_i

    @video = Video.where(id:video_id).first
    redirect_to_error_page "抱歉，你选择的视频不存在或者已被删除" if @video.nil?

    title = params[:title].to_s
    halt_json(res:false, msg: "请输入视频名称") if title.blank?

    video_path = params[:video_path]
    if video_path and video_path.class == Hash
      @video.video_path = video_path
    end

    @video.title = title

    if !@video.save
      redirect_to_error_page
    end
    redirect_to request.referer || "/admin"
  end

  #删除视频
  def do_destroy_video
    video_id = params[:id].to_i
    halt_json(res:true) if video_id <= 0

    @video = Video.where(id:video_id).first
    @video.destroy if @video
    halt_json(res:true)
  end

  #单个视频预览地址
  def single_video_page
    video_id = params[:id].to_i

    @video = Video.where(id:video_id).first
    halt_404 if @video.nil?

    halt_page(:single_video_page)
  end

  #当前视频管理页
  def hot_video_page

    videos = Video.reverse_order(:id).all

    @videos_dict = {}
    videos.each do |video|
      @videos_dict[video.id] = video
    end

    @pids ={}
    hot = Meta.where(name: 'hot_video', page: 1).first
    if hot
      ids = hot.content.to_s.split(",")
      ids.each do |vid|
        vid = vid.to_i
        next if vid<=0 or @videos_dict[vid].nil?
        @pids[vid] = vid
      end
    end

    halt_page(:hot_video_page)
  end

  #更新当前视频
  def update_hot_video

    ids_str = params[:ids].to_s
    ids_arr = ids_str.split(",")

    genenrate_ids_arr = [] 

    ids_arr.each do |pid|
      pid = pid.to_i
      next if pid <= 0
      video = Video.where(id:pid).first
      if video
        genenrate_ids_arr << video.id
      end
    end

    hot = Meta.where(name: 'hot_video', page: 1).first

    max_size = 6
    if hot
      current_ids_arr = hot.content.to_s.split(",")
      if current_ids_arr.length > max_size
        need_repair = true
      end
    end

    if need_repair
      genenrate_ids_arr = genenrate_ids_arr.first(max_size)
    elsif genenrate_ids_arr.length > max_size
      halt_json(res: false, msg: "抱歉，当前视频数量不能超过#{max_size}个")
    end

    genenrate_ids_str =genenrate_ids_arr.uniq.join(",")

    if hot
      hot.update(content: genenrate_ids_str)
    else
      Meta.create(content: genenrate_ids_str, name: 'hot_video')
    end
    halt_json(res:true)
  end




  #分类管理页
  def category_page

    @categories = Category.where(father:nil).reverse_order(:id).all

    halt_page(:category_page)
  end

  #新建分类页表单
  def new_category_page

    halt_page(:new_category_page)
  end

  #创建分类
  def do_create_category

    name, title = params[:name].to_s, params[:title].to_s
    halt_json(res:false, msg: "请输入主分类ID") if name.blank?

    halt_json(res:false, msg: "主分类ID格式不正确，仅支持英文字母、数字以及下划线") if !name_regex_match?(name)

    halt_json(res:false, msg: "请输入主分类名称") if title.blank?

    category = Category.new
    category.name = name
    category.title = title
    category.save

    halt_json(res:true)
  end

  #编辑分类信息表单页
  def edit_category_page

    @category = get_category_by_id(params[:id])
    halt_404 if @category.nil?

    halt_page(:edit_category_page)
  end

  #更新分类信息
  def do_update_category

    category = Category.where(id: params[:id].to_i).first
    halt_json(res:false, msg: "指定主分类不存在") if category.nil?

    name, title = params[:name].to_s, params[:title].to_s
    halt_json(res:false, msg: "请输入主分类ID") if name.blank?

    halt_json(res:false, msg: "主分类ID格式不正确，仅支持英文字母、数字以及下划线") if !name_regex_match?(name)

    halt_json(res:false, msg: "请输入主分类名称") if title.blank?

    category.name = name
    category.title = title
    category.save

    halt_json(res:true)
  end

  #删除分类
  def do_destroy_category

    @category = get_category_by_id(params[:id])
    @category.destroy if @category
    halt_json(res:true)
  end


  def edit_category_logo_page

    @category = get_category_by_id(params[:id])
    halt_404 if @category.nil?

    halt_page(:edit_category_logo_page)
  end

  def do_update_category_logo

    @category = get_category_by_id(params[:id])
    redirect_to_error_page "抱歉，你选择的分类不存在或者已被删除" if !@category

    logo_path = params[:logo_path]
    redirect_to_error_page "抱歉，更新分类图片失败" if logo_path.nil? or logo_path.class != Hash

    @category.logo_path = logo_path
    if !@category.save
      redirect_to_error_page
    end
    redirect_to request.referer || "/admin"
  end


  def edit_password_page

    halt_page(:edit_password_page)
  end

  def do_update_password

    current_password = params[:current_password].to_s
    halt_json(res:false, msg: "请先输入当前密码") if current_password.blank?
    halt_json(res:false, msg: "当前密码输入错误") if current_password != @admin.password

    username, email, password, password_confirmation = params[:username].to_s, params[:email].to_s, params[:password].to_s, password_confirmation.to_s
    error_msg = _fetch_update_password_error_msg(username, email, password, password_confirmation)
    halt_json(res:false, msg: error_msg) if error_msg

    is_changed = username!=@admin.username || email!=@admin.email || (password.present? && password!=@admin.password)

    p is_changed

    if is_changed
      @admin.username = username
      @admin.email = email
      @admin.password = password if password.present?
      if !@admin.save
        halt_error
      end
      cookies[:token] = nil
      flash[:notice] = "管理员信息发生变更，请重新登录"
    end

    halt_json(res: true)
  end

  def _fetch_update_password_error_msg(username, email, password=nil, password_confirmation=nil)

    if username.blank?
      return "请输入用户名"
    elsif username.length <= 2
      return "用户名太短"
    elsif username.length > 15
      return "用户名太长了"
    elsif !Admin.username_regex_match?(username)
      return "用户名只支持英文,数字和下划线，且首字母必须为英文"
    end

    if email.blank?
      return "请输入邮箱地址"
    elsif !Admin.email_regex_match?(email)
      return "邮箱地址无效"
    end

    if password.blank?
      #nothing
    elsif password.length < 6
      return "为了安全起见，密码长度至少6位"
    elsif password_confirmation.blank?
      return "请再输入一次密码"
    elsif password != password_confirmation
      return "两次输入的密码不一致，请重新输入"
    end

    nil
  end


  # 登录页
  def login_page

    @to_url = params[:to_url].to_s

    halt erb_partial(:login_page)
  end

  # 登陆
  def login_action

    account = params[:account].to_s
    password = params[:password].to_s
    
    halt_json(res: false, msg: "请输入账号") if account.blank?

    halt_json(res: false, msg: "请输入密码") if password.blank?

    client_ip = get_client_ip
    halt_json(res: false, msg: "无法获取客户端IP") if client_ip.blank?

    user = Admin.authenticate(account,password)
    halt_json(res: false, msg: "账号或密码不正确") if user.nil?

    token = Admin.generate_token(user,client_ip)

    cookies[:token] = token

    to_url = params[:to_url].presence
    to_url ||= "/admin"

    halt_json(res: true, redirect: to_url)
  end

  def logout_action
    
    cookies[:token] = nil

    redirect_to "/admin"
  end

  private

  def name_regex_match?(name)
    return false if name.blank?
    name == name.match(/\A[a-zA-Z0-9_]+\z/).to_s
  end


end