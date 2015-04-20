class CreateCategoryDescription < ActiveRecord::Migration
  def change
    create_table :tb_category_description do |t|
      
      t.string :category_name, limit: 191
      t.string :content, limit: 9000

      t.timestamps
    end
    add_index :tb_category_description, :category_name, :unique => true
  end
end
