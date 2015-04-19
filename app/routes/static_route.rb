
class StaticRoute < Sinarey::Application

  def halt_public_folder
    path = File.expand_path("#{Sinarey.root}/public#{unescape(request.path_info)}" )
    halt 404,'404' unless File.file?(path)
    env['sinatra.static_file'] = path
    send_file path, :disposition => nil
  end

  def halt_file(filepath)
    halt 404,'404' unless filepath.present? and File.file?(filepath)
    env['sinatra.static_file'] = filepath
    send_file filepath, :disposition => nil
  end


  get '/assets/*' do
    halt_public_folder
  end

  get '/favicon.ico' do
    halt_public_folder
  end

end
