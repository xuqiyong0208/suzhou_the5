
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

  #公司简介管理页
  def intro_page

    record = Intro.first
    @content = record.content if record

    halt_page(:intro_page)
  end

  #修改公司简介
  def do_update_intro
    content = params[:content].to_s
    record = Intro.first
    if record
      record.update(content:content)
    else
      Intro.create(content:content)
    end
    halt_json(res: true)
  end

  #联系我们管理页
  def contact_page
    record = Contact.first
    @content = record.content if record
    halt_page(:contact_page)
  end

  #修改联系我们
  def do_update_contact
    content = params[:content].to_s
    record = Contact.first
    if record
      record.update(content:content)
    else
      Contact.create(content:content)
    end
    halt_json(res: true)
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

    hot = HotProduction.first
    if hot
      ids = hot.ids.to_s.split(",")
      ids.each do |num|
        next if num.blank?
        num = num.to_i
        @pids[num] = num
      end
    end

    halt_page(:hot_production_page)
  end

  #更新热销产品
  def update_hot_production

    ids_arr = Array.wrap(params[:ids])
    ids_str = ids_arr.join(",")

    hot = HotProduction.first
    if hot
      hot.update(ids: ids_str)
    else
      HotProduction.create(ids: ids_str)
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
    if @production
      cover_path = params[:cover_path]
      if cover_path and cover_path.class == Hash
        @production.cover_path = cover_path
        @production.save
      end
    end
    redirect_to request.referer || "/admin"
  end

  #删除产品
  def do_destroy_production

    @production = get_production_by_id(params[:id])
    @production.destroy if @production
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
    if @category
      logo_path = params[:logo_path]
      if logo_path and logo_path.class == Hash
        @category.logo_path = logo_path
        @category.save
      end
    end

    redirect_to request.referer || "/admin"
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