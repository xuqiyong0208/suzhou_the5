
CarrierWave.configure do |config|
  
  config.delete_tmp_file_after_storage = true
  config.ignore_download_errors = false
  config.cache_dir = "#{Sinarey.root}/public/assets/uploads/tmp/cache/"

  #客户不使用aliyun oss服务
  if false && Sinarey.env == "production"
    config.aliyun_access_id = "xxxxuyyyzzz"
    config.aliyun_access_key = 'jjjgwfewf12qwdfqd443wdqw'

    # # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
    config.aliyun_bucket = "xyz123ghy"
    
    config.storage = :aliyun

    # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
    config.aliyun_internal = true
    config.aliyun_host = "xyz123ghy.oss-internal.aliyuncs.com"
  else
    config.storage = :file
    config.root = Sinarey.root.to_s + "/public"
  end

end
