user "celery"

directory "/var/run/celery" do
  owner "celery"
end

directory "/var/lib/celery" do
  owner "celery"
end

celery_worker_command = "python manage.py celery worker "
celery_worker_options = {
  "broker" => node["twoscoops"]["celery"]["broker"],
  "concurrency" => node["twoscoops"]["celery"]["concurrency"],
  "queues" => "celery",
  "loglevel" => "INFO"
}.each do |k,v|
  celery_worker_command = celery_worker_command + "--#{k}=#{v} "
end

supervisor_service "celery-worker" do
  command celery_worker_command
  user "celery"
  autostart true
  directory "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  stdout_logfile "#{node['twoscoops']['application_path']}/logs/celery_worker.log"
  stderr_logfile "#{node['twoscoops']['application_path']}/logs/celery_worker.log"
  action :enable
end

celery_beat_command = "python manage.py celery beat "
celery_beat_options = {
  "broker" => node["twoscoops"]["celery"]["broker"],
  "pidfile" => "/var/run/celery/celery-beat.pid",
  "schedule" => "/var/lib/celery/celerybeat-schedule",
  "loglevel" => "INFO"
}.each do |k,v|
  celery_beat_command = celery_beat_command + "--#{k}=#{v} "
end

supervisor_service "celery-beat" do
  command celery_beat_command
  user "celery"
  autostart true
  directory "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  stdout_logfile "#{node['twoscoops']['application_path']}/logs/celery_beat.log"
  stderr_logfile "#{node['twoscoops']['application_path']}/logs/celery_beat.log"
  action :enable
end
