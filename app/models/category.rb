
class Category < Sequel::Model

	set_dataset :tb_category

	set_allowed_columns :title, :name, :father,

                      :logo_path, :logo_path_cache, :remove_logo_path,
                      :cover_path, :cover_path_cache, :remove_cover_path

  mount_uploader :logo_path, CategoryLogoUploader
  mount_uploader :cover_path, CategoryCoverUploader

end
