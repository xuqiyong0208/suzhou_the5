# encoding: utf-8

require 'mini_magick'
require 'carrierwave/processing/mime_types'

class CategoryLogoUploader < CarrierWave::Uploader::Base

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

  process :resize_to_fill  => [50, 50]

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
