class CreateVideo < ActiveRecord::Migration
  def change
    create_table :tb_video do |t|

      t.string :title, limit: 191      
      t.string :video_path, limit: 191

      t.timestamps
    end
  end
end
