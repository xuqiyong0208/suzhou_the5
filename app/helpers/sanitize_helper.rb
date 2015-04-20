
module SanitizeHelper

	require 'sanitize'

  def simple_content(content) 
    return "" unless content.present?
    content.to_s.gsub("\n\r","<br />").gsub("\r", "").gsub("\n", "<br />")
  end

  def simple_format(content)
    return "" unless content.present?
    content = simple_content(content.to_s)
    Sanitize.clean(content, :elements => ['a','br','img'], :attributes => {'a' => ['href','target'], 'img' => ['src','alt']})
  end

	def sanitize_content(content)
		return "" unless content.present?
		Sanitize.clean(content.to_s, :elements => ['a','br','img','p','pre','b','strong','i','em','blockquote','sup','span'],
		    :attributes => {'img' => ['src','alt','width','height'], 'a' => ['href','target']})
	end

end
