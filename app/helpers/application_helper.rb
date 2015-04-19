
module ApplicationHelper

  def form_authenticity_token
    session[:_csrf_token] || set_session(:_csrf_token, SecureRandom.base64(32), force: true)
  end

  #检测是否登录
  def signed_in?
      @current_user.present?
  end

  def request_pjax?
    env["IS_PJAX_REQUEST"]==true
  end

  def requirejs_base_url
    @temp[:version_path] ||= Settings.static_version.presence && "/#{Settings.static_version}"
    "#{Settings.static_root}#{@temp[:version_path]}/js/lib"
  end

  #静态文件url
  def static_url(file)
    @temp[:version_path] ||= Settings.static_version.presence && "/#{Settings.static_version}"
    File.join("#{Settings.static_root}","#{@temp[:version_path]}","#{file}")
  end

  #获取文件url
  def file_url(file_path)
    return file_path if file_path.nil? or file_path.empty?
    file_path.match(/^http/) ? file_path : File.join(Settings.oss_root, file_path)
  end

  def get_client_ip
    @temp[:client_ip] ||= env['X-Real-IP'] || request.ip
  end

  #检测IE6
  def oldIE?
      @temp[:oldIE] ||= (request.user_agent && request.user_agent.match(/(?i)msie [1-7]/)) ? 1 : 0
      @temp[:oldIE] == 1
  end

  #检测是否为管理员
  def admin?
    @temp[:is_admin] ||= (
      if @current_uid
        admin_uids = [1]
        is_admin = admin_uids.include? @current_uid
        is_admin ? 1 : 0
      else
        0
      end )
    @temp[:is_admin] == 1
  end

  def params_page
    @temp[:params_page] ||= (
      if params[:page].present?
        params[:page].to_i
      else
        1
      end
    )
  end

  #设置分页的默认值
  def paginate(sequel_pagination = nil, options = {})
    options[:previous_label] ||= '上一页'
    options[:next_label] ||= '下一页'
    options[:inner_window] ||= 3
    options[:outer_window] ||= 0
    options[:params] = params if request.post?
    temp = PaginateTemp.new(sequel_pagination)
    will_paginate(temp, options)
  end

end