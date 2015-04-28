
class Base < Sequel::Model

	set_dataset :tb_base

	set_allowed_columns :title, :name, :intro,

                      :cover_path, :cover_path_cache, :remove_cover_path

  mount_uploader :cover_path, BaseCoverUploader

end
