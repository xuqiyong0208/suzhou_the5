
class Category < Sequel::Model

	set_dataset :tb_category

	set_allowed_columns :title, :name, :father, :logo_class, :cover_pic_path

end
