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
    @videos = []
    if hot
      ids = hot.content.to_s.split(",")
      if ids.present?
        original_videos = Video.where(id: ids)
        video_dict = {}
        original_videos.each do |video|
          video_dict[video.id] = video
        end
        ids.each do |id|
          video = video_dict[id.to_i]
          next if video.nil?
          @videos << video
        end
      end
    end
    halt_page(:index_page)
  end

  #产品中心
  def production_page

    set_categories_and_banners

    hot = Meta.where(name: 'hot_production', page: 1).first
    @productions = []
    if hot
      ids = hot.content.to_s.split(",")
      if ids.present?
        ids.each do |id|
          production = @category_with_id[id.to_i].nil?
          next if production.nil?
          @productions << production
        end
      end
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

  def base_page
    set_categories_and_banners

    hot = Meta.where(name: 'hot_base', page: 1).first
    @bases = []
    if hot
      ids = hot.content.to_s.split(",")
      if ids.present?
        original_bases = Base.where(id: ids)
        base_dict = {}
        original_bases.each do |base|
          base_dict[base.id] = base
        end
        ids.each do |id|
          base = base_dict[id.to_i]
          next if base.nil?
          @bases << base
        end
      end
    end
    halt_page(:base_page)
  end

  def single_base_page

    @base = Base.where(name: params[:name]).first
    halt_404 if @base.nil?

    record = BaseDescription.where(base_id: @base.id).first
    @content = (record && record.content).to_s

    halt_page(:single_base_page)
  end

end