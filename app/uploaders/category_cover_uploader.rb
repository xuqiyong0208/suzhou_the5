# encoding: utf-8

require 'mini_magick'
require 'carrierwave/processing/mime_types'

class CategoryCoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

  include CarrierWave::MiniMagick

  def store_dir
    "#{Sinarey.root}/public/assets/carrier_wave/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    nil
    #{}"/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  process :resize_to_fill => [368, 200]

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
