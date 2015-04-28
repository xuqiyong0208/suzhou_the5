# encoding: utf-8

require 'mini_magick'
require 'carrierwave/processing/mime_types'

class BaseCoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

  include CarrierWave::MiniMagick

  version :thumb do
    process :resize_to_fill => [368, 200]
  end


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
