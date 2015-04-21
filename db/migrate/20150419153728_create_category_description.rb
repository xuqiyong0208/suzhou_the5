class CreateCategoryDescription < ActiveRecord::Migration
  def change
    create_table :tb_category_description do |t|
      
      t.integer :category_id
      t.string :content, limit: 9000

      t.timestamps
    end
    add_index :tb_category_description, :category_id, :unique => true
  end
end
