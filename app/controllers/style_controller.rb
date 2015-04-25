class StyleController < ApplicationController

  include SanitizeHelper

  set :views, ['style','application']

  def dispatch(action,options={})
    super(StyleController,action)
    method(action).call
  end

  #首页
  def index_page

    set_categories_and_banners

    hot = Meta.where(name: 'hot_video', page: 1).first
    if hot
      ids = hot.content.to_s.split(",")
    else
      ids = []
    end

    @videos = []

    ids.each do |id|
      id = id.to_i
      next if id < 0
      video = Video.where(id: id).first
      @videos << video if video
    end

    halt_page(:index_page)
  end

  #产品中心
  def production_page

    set_categories_and_banners

    hot = Meta.where(name: 'hot_production', page: 1).first
    if hot
      ids = hot.content.to_s.split(",")
    else
      ids = []
    end

    @productions = []

    ids.each do |id|
      id = id.to_i
      next if id < 0
      production = @category_with_id[id]
      @productions << production if production
    end

  	halt_page(:production_page)
  end

  def single_production_page

    set_categories_and_banners(params[:name])

    halt_404 if @category.nil?

    _single_category_page if @categories[@category.id].present?

    record = CategoryDescription.where(category_id: @category.id).first
    @content = (record && record.content).to_s
    
  	halt_page(:single_production_page)
  end

  def _single_category_page

    @productions = @categories[@category.id]

    halt_page(:_single_category_page)
  end

  def about_page

    set_banners

    @intro = Meta.where(name: 'intro', page: 1).first
  	halt_page(:about_page)
  end

  def contact_page

    set_banners

    @contact = Meta.where(name: 'contact', page: 1).first
  	halt_page(:contact_page)
  end

end