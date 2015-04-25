# encoding: utf-8

#require 'carrierwave/processing/mime_types'

class VideoUploader < CarrierWave::Uploader::Base

  # include CarrierWave::MimeTypes
  # process :set_content_type

  def store_dir
    "#{Sinarey.root}/public/assets/carrier_wave/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  def default_url
    nil
  end

  def filename
    "f.mp4" if original_filename
  end

  def extension_white_list
    %w(mp4)
  end

end
