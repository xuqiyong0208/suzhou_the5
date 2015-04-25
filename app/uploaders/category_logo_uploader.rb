# encoding: utf-8

require 'mini_magick'
require 'carrierwave/processing/mime_types'

class CategoryLogoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

  include CarrierWave::MiniMagick

  process :resize_to_fill  => [50, 50]


  def store_dir
    "#{Sinarey.root}/public/assets/carrier_wave/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    nil
  end

  def filename
    "image" if original_filename
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
