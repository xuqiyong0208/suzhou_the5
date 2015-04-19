class CreateAdmin < ActiveRecord::Migration
  def change
    create_table :tb_admin do |t|
      
      t.string :username, limit: 191
      t.string :email, limit: 191
      t.string :password, limit: 191

      t.timestamps
    end
    add_index :tb_admin, :username, :unique => true
    add_index :tb_admin, :email, :unique => true
  end
end
