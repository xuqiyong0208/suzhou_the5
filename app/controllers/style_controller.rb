class StyleController < ApplicationController

  set :views, ['style','application']

  def dispatch(action,options={})
    super(StyleController,action)
    method(action).call
  end

  #首页
  def index_page

    set_categories

    # @categories.each do |category|
    #   p category
    # end

    halt_page(:index_page)
  end

  #产品中心
  def production_page

    set_categories

  	halt_page(:production_page)
  end


  def single_production_page

    set_categories(params[:name])

    halt_404 if @category.nil?

  	halt_page(:single_production_page)
  end

  def about_page

  	halt_page(:about_page)
  end

  def contact_page

  	halt_page(:contact_page)
  end

  private

  def set_categories(name=nil)
    categories = Category.all
    @category = nil
    @categories = {root: []}
    categories.each do |category|
      father = category.father
      if father.present?
        (@categories[father] ||= []) << category
      else
        @categories[:root] << category
      end
      @category = category if name && name == category.name
    end
  end

end