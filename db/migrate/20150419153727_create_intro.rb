class CreateIntro < ActiveRecord::Migration
  def change
    create_table :tb_intro do |t|
      
      t.string :content, limit: 9000

      t.timestamps
    end
    add_index :tb_intro, :content
  end
end
