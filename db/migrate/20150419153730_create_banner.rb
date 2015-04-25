class CreateBanner < ActiveRecord::Migration
  def change
    create_table :tb_banner do |t|
      
      t.integer :production_id, null: false
      t.string :cover_path, limit: 191, null: false

      t.timestamps
    end
  end
end
