CustomPagination = Struct.new(:pagination_record_count,:current_page,:page_size)

#用于将sequel pagination对象转成will_paginate能处理的对象
class PaginateTemp

  def initialize(sequel_pagination)
    @current_page = sequel_pagination.current_page
    @total_pages = sequel_pagination.pagination_record_count/sequel_pagination.page_size
  end

  def current_page
    @current_page
  end

  def total_pages
    @total_pages
  end

  def previous_page
    @current_page - 1
  end

  def next_page
    @current_page + 1
  end

  def out_of_bounds?
    @current_page > @total_pages
  end
end

module WillPaginate
  module ViewHelpers
    class LinkRenderer < LinkRendererBase
    protected
    
      def page_number(page)
        if page == current_page
          tag(:em, page, :class => 'current')
        else
          if @options[:max_page] && page.to_i > @options[:max_page]
            ""
          else
            "<a href='#{url(page,@options[:url])}' #{@options[:attrs]}>#{page}</a>"
          end
        end
      end
      
      def gap
        text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
        %(<span class="gap">#{text}</span>)
      end
      
      def previous_page
        num = @collection.current_page > 1 && @collection.current_page - 1
        previous_or_next_page(num, @options[:previous_label]||'上一页', 'previous_page', 'prev')
      end
      
      def next_page
        num = @collection.current_page < total_pages && @collection.current_page + 1
        previous_or_next_page(num, @options[:next_label]||'下一页', 'next_page', 'next')
      end

      def previous_or_next_page(page, text, classname, rel=nil)
        if page
          if @options[:max_page] && page.to_i > @options[:max_page]
            ""
          else
            rel_str = " rel='#{rel}'" if rel
            "<a href='#{url(page,@options[:url])}' class='#{classname}'#{rel_str} #{@options[:attrs]}>#{text}</a>"
          end
        end
      end

    end
  end
end

module WillPaginate
  module Sinatra

    class LinkRenderer < ViewHelpers::LinkRenderer
      protected

      def url(page,link=nil)

        str = link || File.join(request.script_name.to_s, request.path_info)

        if page.to_s=='1'
          params = request.GET
          params.delete(param_name.to_s)
        else
          params = request.GET.merge(param_name.to_s => page.to_s)
        end
        params.update @options[:params] if @options[:params]
        query = build_query(params)
        tail = query.present? ? "?#{query}" : ""
        str.dup << tail
      end

      def request
        @template.request
      end

      def build_query(params)
        params.delete("pjax_box_id")
        Rack::Utils.build_nested_query params
      end
    end

  end
end