
class UeditorFile < Sequel::Model

  set_dataset :tb_ueditor_file

  set_allowed_columns :cover_path

  mount_uploader :cover_path, UeditorUploader

end
