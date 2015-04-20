
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
  def category_page
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

    halt_page(:category_page)
  end

  #编辑分类简介页
  def edit_category_description_page

    @category = Category.where(name: params[:name].to_s).first

    record = CategoryDescription.where(category_name: @category.name).first
    @content = record && record.content

    halt_page(:edit_category_description_page)
  end

  #修改分类简介
  def do_update_category_description

    category = Category.where(name: params[:name].to_s).first
    halt_json(res:false, msg: "指定产品不存在") if category.nil?

    content = params[:content].to_s
    record = CategoryDescription.where(category_name: category.name).first
    if record
      record.update(content:content)
    else
      CategoryDescription.create(content:content, category_name: category.name)
    end
    halt_json(res: true)
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

end