class CreateContact < ActiveRecord::Migration
  def change
    create_table :tb_contact do |t|
      
      t.string :content, limit: 9000

      t.timestamps
    end
    add_index :tb_contact, :content
  end
end
