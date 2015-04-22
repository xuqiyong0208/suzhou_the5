class CreateCategory < ActiveRecord::Migration
  def change
    create_table :tb_category do |t|
      
      t.string :name, limit: 191
      t.string :title, limit: 191
      t.integer :father
      
      t.string :intro, limit: 191

      t.string :logo_path, limit: 191
      t.string :cover_path, limit: 191

      t.timestamps
    end
    add_index :tb_category, :name, :unique => true
  end
end
