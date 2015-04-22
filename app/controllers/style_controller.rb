class StyleController < ApplicationController

  include SanitizeHelper

  set :views, ['style','application']

  def dispatch(action,options={})
    super(StyleController,action)
    method(action).call
  end

  #首页
  def index_page

    set_categories

    halt_page(:index_page)
  end

  #产品中心
  def production_page

    set_categories

    hot = HotProduction.first
    if hot
      ids = hot.ids.to_s.split(",")
    else
      ids = []
    end

    @productions = Category.where(id: ids).reverse_order(:id).all

  	halt_page(:production_page)
  end

  def single_production_page

    set_categories(params[:name])

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

    @intro = Intro.first
  	halt_page(:about_page)
  end

  def contact_page

    @contact = Contact.first
  	halt_page(:contact_page)
  end

end