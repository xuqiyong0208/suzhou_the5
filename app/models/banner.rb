
class Banner < Sequel::Model

  set_dataset :tb_banner

  set_allowed_columns :production_id, :cover_path

  mount_uploader :cover_path, BannerCoverUploader

end
