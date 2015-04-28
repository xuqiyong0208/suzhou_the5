class CreateUeditorFile < ActiveRecord::Migration
  def change
    create_table :tb_ueditor_file do |t|
      
      t.string :cover_path, limit: 191

      t.timestamps
    end
  end
end
