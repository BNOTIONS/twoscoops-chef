if node['twoscoops']['celery']['broker_url'].start_with?('amqp')
  include_recipe "rabbitmq"
end

include_recipe "supervisor"

if node['twoscoops']['application_revision'] == nil
  celery_path = "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
else
  celery_path = "#{node['twoscoops']['application_path']}/#{node['twoscoops']['application_name']}/current/#{node['twoscoops']['project_name']}"
end

celery_env = {
  "PYTHON_PATH" => celery_path,
  "SECRET_KEY" => node['twoscoops']['secret_key'],
  "DJANGO_SETTINGS_MODULE" => "#{node['twoscoops']['project_name']}.settings.#{node['twoscoops']['application_environment']}"
}

user "celery"

directory "/var/run/celery" do
  owner "celery"
end

directory "/var/lib/celery" do
  owner "celery"
end

directory "#{node['twoscoops']['application_path']}/logs/celery" do
  owner "celery"
  recursive true
end

template "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}/#{node['twoscoops']['project_name']}/settings/celery_settings.py" do
  source "celery.py.erb"
  mode 00644
  only_if { node['twoscoops']['application_revision'].nil? }
end

#celeryd_command = "celeryd --app=#{node['twoscoops']['project_name']} "
#celeryd_options = {
#  "broker" => node["twoscoops"]["celery"]["broker_url"],
#  "concurrency" => node["twoscoops"]["celery"]["concurrency"],
#  "queues" => node["twoscoops"]["celery"]["queues"],
#  "loglevel" => node["twoscoops"]["celery"]["loglevel"]
#}.each do |k,v|
#  celeryd_command = celeryd_command + "--#{k}=#{v} "
#end

supervisor_service "celeryd" do
  command "python manage.py celery worker"
  user "celery"
  autostart node['twoscoops']['celeryd']['autostart']
  directory celery_path
  environment celery_env
  stdout_logfile "#{node['twoscoops']['application_path']}/logs/celery/worker.log"
  stderr_logfile "#{node['twoscoops']['application_path']}/logs/celery/worker.log"
  action :enable
end

#celery_beat_command = "celerybeat "
#celery_beat_options = {
#  "broker" => node["twoscoops"]["celery"]["broker_url"],
#  "pidfile" => "/var/run/celery/celery-beat.pid",
#  "schedule" => "/var/lib/celery/celerybeat-schedule",
#  "loglevel" => node["twoscoops"]["celery"]["loglevel"]
#}.each do |k,v|
#  celery_beat_command = celery_beat_command + "--#{k}=#{v} "
#end

supervisor_service "celery-beat" do
  command "python manage.py celery beat --pidfile=/var/run/celery/celerybeat.pid --schedule=#{node['twoscoops']['celerybeat']['schedule_filename']}"
  user "celery"
  autostart node['twoscoops']['celerybeat']['autostart']
  directory celery_path
  environment celery_env
  stdout_logfile "#{node['twoscoops']['application_path']}/logs/celery/beat.log"
  stderr_logfile "#{node['twoscoops']['application_path']}/logs/celery/beat.log"
  action :enable
end
