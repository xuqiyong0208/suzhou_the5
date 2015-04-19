class StyleController < ApplicationController

  set :views, ['style','application']


  def dispatch(action,options={})
    method(action).call
  end

  #首页
  def index_page

    halt_page(:index_page)
  end

  #产品中心
  def production_page

  	halt_page(:production_page)
  end


  def single_production_page

  	halt_page(:single_production_page)
  end

  def about_page

  	halt_page(:about_page)
  end

  def contact_page

  	halt_page(:contact_page)
  end


end