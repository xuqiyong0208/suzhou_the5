
class Category < Sequel::Model

	set_dataset :tb_category

	set_allowed_columns :title, :name, :father

end
