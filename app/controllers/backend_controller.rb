
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

  #分类管理页面
  def production_page
    @categories = Category.all

    @dict = {}
    @children_exist = {}
    @categories.each do |category|
      @dict[category.name] = category.title
      father = category.father
      if father.present?
        @children_exist[father] ||= true
      end
    end

    halt_page(:production_page)
  end

  #编辑产品信息页
  def edit_production_page

    @category = Category.where(id: params[:id].to_i).first

    record = CategoryDescription.where(category_id: @category.id).first
    @content = record && record.content

    halt_page(:edit_production_page)
  end

  #修改产品信息
  def do_update_production

    category = Category.where(id: params[:id].to_i).first
    halt_json(res:false, msg: "指定产品不存在") if category.nil?

    name, title = params[:name].to_s, params[:title].to_s
    halt_json(res:false, msg: "请输入产品ID") if name.blank?

    halt_json(res:false, msg: "产品ID格式不正确，仅支持英文字母、数字以及下划线") if !name_regex_match?(name)

    halt_json(res:false, msg: "请输入产品名称") if title.blank?

    category.name = name
    category.title = title
    category.save

    content = params[:content].to_s
    record = CategoryDescription.where(category_id: category.id).first
    if record
      record.update(content:content)
    else
      CategoryDescription.create(content:content, category_id: category.name)
    end
    halt_json(res:true)
  end

  #编辑产品信息页
  def edit_production_cover_page

    @category = Category.where(id: params[:id].to_i).first

    halt_page(:edit_production_cover_page)
  end

  #更新产品图片
  def do_update_production_cover
    @category = Category.where(id: params[:id].to_i).first
    if @category
      cover_path = params[:cover_path]
      if cover_path and cover_path.class == Hash
        @category.cover_path = cover_path
        p cover_path
        @category.save
      end
    end
    redirect_to request.referer || "/admin"
  end

  # 主分类管理页
  def category_page

    @categories = Category.where(father:nil).all

    halt_page(:category_page)
  end

  #编辑主分类信息页
  def edit_category_page

    @category = Category.where(id: params[:id].to_i).first

    halt_page(:edit_category_page)
  end

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

    content = params[:content].to_s
    record = CategoryDescription.where(category_id: category.id).first
    if record
      record.update(content:content)
    else
      CategoryDescription.create(content:content, category_id: category.name)
    end
    halt_json(res:true)
  end


  def edit_category_logo_page
    "edit_category_logo_page called"
  end

  def do_update_category_logo
    "do_update_category_logo called"
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