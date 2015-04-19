
module SanitizeHelper

	require 'sanitize'

  def simple_format(string)
    return '' if string.empty?
    string = string.gsub("\n\r","<br />").gsub("\r", "").gsub("\n", "<br />")
    Sanitize.clean(string, :elements => ['a','br','img'], :attributes => {'a' => ['href','target'], 'img' => ['src','alt']})
  end

	def sanitize_content(content)
		return "" unless content.present?
		Sanitize.clean(content, :elements => ['embed','p','img','pre','b','strong','i','em','blockquote','sup','span'],
		    :attributes => {'embed' => embed_allowed_attrs,
		    								'img' => ['src','alt','width','height'],'span' => ['style']})
	end

	#只保留第一个embed元素
	def sanitize_embed_summary(content)
		return "" unless content.present?
		embed_count = 0
		transformer = lambda do |env|
		  node      = env[:node]
		  node_name = env[:node_name]
		  return node.unlink if node_name=="text"
		  if node_name=="embed"
		  	embed_count += 1
		  	return node.unlink if embed_count>1
		  end
		  return if env[:is_whitelisted] || !node.element?
		  Sanitize.clean_node!(node, {:elements => ['embed'],
							:attributes => {'embed' => embed_allowed_attrs}})
		  {:node_whitelist => [node]}
		end
		Sanitize.clean(content, :transformers => transformer)
	end

	#只保留前三张img元素
	def sanitize_three_img(content)
		return "" unless content.present?
		img_count = 0
		transformer = lambda do |env|
		  node      = env[:node]
		  node_name = env[:node_name]
		  return node.unlink if node_name=="text"
		  if node_name=="img"
		  	img_count += 1
		  	return node.unlink if img_count>3
		  end
		  return if env[:is_whitelisted] || !node.element?
		  Sanitize.clean_node!(node, {:elements => ['img'],
							:attributes => {'img' =>['src']}})

		  {:node_whitelist => [node]}
		end
		Sanitize.clean(content, :transformers => transformer)

	end

	def sanitize_link_intro(content)
		return "" unless content.present?
		Sanitize.clean(content, :elements => ['a'], :attributes => {'a' => ['href','target']})
	end

	def sanitize_all(content)
		return "" unless content.present?
		Sanitize.clean(content)
	end

	private

	def embed_allowed_attrs
		['type','pluginspage','src','width','height','edui-faked-video','wmode','play','loop','align','menu','allowscriptaccess','allowfullscreen']
	end

end
