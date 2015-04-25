class CreateMeta < ActiveRecord::Migration
  def change
    create_table :tb_meta do |t|
      
      t.string :content, limit: 9000

      t.string :name, limit: 191, null: false
      t.integer :page, null: false, default: 1

      t.timestamps
    end
    add_index :tb_meta, [:name, :page], :unique => true
  end
end
