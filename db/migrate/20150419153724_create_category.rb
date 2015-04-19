class CreateCategory < ActiveRecord::Migration
  def change
    create_table :tb_category do |t|
      
      t.string :name, unique: true
      t.string :title
      t.string :father

      t.timestamps
    end
    add_index :tb_category, :name
  end
end
