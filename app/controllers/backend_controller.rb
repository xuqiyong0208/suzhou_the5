
class BackendController < ApplicationController

  before do
    set_current_admin
    require_admin_filter if request.fullpath != "/admin"
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

    p token
    p "--------------------"

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