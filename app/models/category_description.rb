
class CategoryDescription < Sequel::Model

  set_dataset :tb_category_description

  set_allowed_columns :content, :category_id

end
