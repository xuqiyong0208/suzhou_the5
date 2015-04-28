class CreateBase < ActiveRecord::Migration
  def change
    create_table :tb_base do |t|
      
      t.string :name, limit: 191
      t.string :title, limit: 191

      t.string :intro, limit: 191

      t.string :cover_path, limit: 191

      t.timestamps
    end
    add_index :tb_base, :name, :unique => true
  end
end
