
class Video < Sequel::Model

  set_dataset :tb_video

  set_allowed_columns :title, :video_path

  mount_uploader :video_path, VideoUploader

end
