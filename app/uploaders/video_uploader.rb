# encoding: utf-8

require 'carrierwave/processing/mime_types'

class VideoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

  def store_dir
    "#{Sinarey.root}/public/assets/carrier_wave/video/"
  end

  def default_url
    nil
    #{}"/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  def extension_white_list
    %w(mp4 flv)
  end

end
