class CreateBaseDescription < ActiveRecord::Migration
  def change
    create_table :tb_base_description do |t|
      
      t.integer :base_id
      t.string :content, limit: 9000

      t.timestamps
    end
    add_index :tb_base_description, :base_id, :unique => true
  end
end
