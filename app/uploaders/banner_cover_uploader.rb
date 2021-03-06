# encoding: utf-8

require 'carrierwave/processing/mime_types'

class BannerCoverUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

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
