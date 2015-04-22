class CreateHotProduction < ActiveRecord::Migration
  def change
    create_table :tb_hot_production do |t|
      
      t.text :ids

      t.timestamps
    end
  end
end
