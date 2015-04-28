pidfile File.expand_path('tmp/pids/puma.production.pid',__dir__)
bind 'tcp://0.0.0.0:8080'
threads 5,20
quiet

environment 'production'

stdout_redirect 'log/puma.stdout.log', 'log/puma.stdout.log'

workers 4
worker_timeout 10


on_worker_boot do
 #nothing
end

on_restart do
 #nothing
end

