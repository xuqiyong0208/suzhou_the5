
class ApplicationController < Sinarey::Application

  helpers ApplicationHelper

  set :views, ['application']
  
  before do
    @temp = {}
    @temp[:request_time] = Time.now
  end

  after do
    if true or Sinarey.env == 'production'
      server_time = ((Time.now-@temp[:request_time])*1000).to_i
      request_method = @temp[:request_method] || request.request_method
      accesslog "#{Time.now.strftime('%H:%M:%S')} | #{request_method.ljust(4)} | #{request.fullpath}"+" | _#{response.status}_ | #{@temp[:response_cache_flag]} | #{server_time.to_s.ljust(3)}ms | #{get_client_ip} | #{request.host} | #{request.referrer} | #{request.user_agent}"
    end
  end

  error do
    halt_500
  end

  def dispatch(klass,action,options={})
    @temp[:controller] = controller2sym(klass)
    @temp[:action] = action
    set_basic_cache_header
  end

  #未登录
  def halt_400
    halt 400,'未登录'
  end

  #没有权限
  def halt_401
    halt 401,'你没有权限进行该操作'
  end

  #资源不存在
  def halt_404(msg='')
    halt 404, erb(:page_404)
  end

  #操作失败
  def halt_500(msg='')
    dump_errors
    halt 500, erb(:page_500)
  end

  #错误提示
  def halt_error(msg='')
    @msg = msg.presence || "抱歉，服务器繁忙，请稍后重试"
    halt 500, erb(:page_error)
  end

  #请求有误
  def halt_412(msg='')
    text = "参数错误。"
    text += " #{msg}" if msg
    halt 412,text
  end

  def halt_json(json)
    content_type :json
    halt Oj.dump(json, mode: :compat)
  end

  def render_to_string(options)
    partial = options.delete(:partial)
    args = {layout:false}.merge(options)
    erb partial, args
  end


  def redirect_to(route)
    redirect route, 303
  end

  def erb_partial(partial)
    erb(partial,layout:false)
  end

  def halt_js(javascript)
    set_no_cache_header
    content_type 'text/javascript'
    halt javascript
  end

  def halt_page(partial)
    page = erb(partial)
    halt page
  end

  def halt_erb_js(partial)
    page = erb_partial(partial)
    halt page
  end

  def set_basic_cache_header
    response["Cache-Control"] = "max-age=0"
  end

  def set_no_cache_header
    response["Cache-Control"] = "no-store"
  end

  def get_production_by_id(id)
    id = id.to_i
    return if id.to_i <= 0
    production = Category.where(id: id).first
    return if production.nil?

    sub_category_size = Category.where(father: production.id).count
    return if sub_category_size > 0

    production
  end

  def get_category_by_id(id)
    id = id.to_i
    return if id <= 0
    category = Category.where(id: id, father: nil).first
    return if category.nil?

    category
  end

  def get_all_categories
    Category.reverse_order(:id).all
  end

  def set_banners(product_dict=nil)
    bannar_meta = Meta.where(name: 'hot_banner', page: 1).first
    if bannar_meta
      banner_ids = bannar_meta.content.to_s.split(",").map(&:to_i)
    else
      banner_ids = []
    end

    banners = Banner.where(id: banner_ids).all

    if !product_dict
      pids = banners.map(&:production_id).uniq
      product_dict = {}
      productions = Category.where(id: pids).all
      productions.each do |product|
        product_dict[product.id] = product
      end
    end

    banner_dict = {}
    banners.each do |banner|
      next if banner.cover_path.url.blank? or (production = product_dict[banner.production_id]).nil?
      banner_dict[banner.id] = {cover_url: banner.cover_path.url, production_name: production.name}
    end

    @banners = []
    banner_ids.each do |banner_id|
      banner = banner_dict[banner_id]
      next if banner.nil?
      @banners << banner
    end
  end

  def set_categories_and_banners(name=nil)
    categories = get_all_categories
    @category = nil
    @category_with_id = {}
    @categories = {root: []}
    categories.each do |category|
      father = category.father
      if father.present?
        (@categories[father] ||= []) << category
      else
        @categories[:root] << category
      end
      @category_with_id[category.id] = category
      @category = category if name && name == category.name
    end
    set_banners(@category_with_id)
  end

end