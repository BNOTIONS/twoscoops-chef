#
# Cookbook Name:: twoscoops
# Recipe:: local
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "twoscoops::base"
include_recipe "twoscoops::database"
include_recipe "rabbitmq"
include_recipe "supervisor"

directory "#{node['twoscoops']['application_path']}/logs" do
  action :create
  mode 00755
end

template "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}/#{node['twoscoops']['project_name']}/settings/database.py" do
  source "database.py.erb"
  mode 00644
end

execute "pip-install-requirements" do
  cwd "#{node['twoscoops']['application_path']}"
  command "pip install -r requirements/local.txt"
end

execute "django-syncdb" do
  cwd "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  command "python manage.py syncdb --noinput"
end

directory "/tmp/twoscoops/fixtures" do
  recursive true
  action :create
  mode 00755
end

template "/tmp/twoscoops/fixtures/createsuperuser.json" do
  source "createsuperuser.json.erb"
end

execute "django-createsuperuser" do
  cwd "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  command "python manage.py loaddata /tmp/twoscoops/fixtures/createsuperuser.json"
end

execute "django-migrate" do
  cwd "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  command "python manage.py migrate"
end

supervisor_service "#{node['twoscoops']['project_name']}" do
  command "python manage.py runserver 0.0.0.0:8080"
  autostart true
  directory "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  stdout_logfile "#{node['twoscoops']['application_path']}/logs/django.log"
  stderr_logfile "#{node['twoscoops']['application_path']}/logs/django_error.log"
  action :enable
end

user "celery"

directory "/var/run/celery" do
  owner "celery"
end

directory "/var/lib/celery" do
  owner "celery"
end

celery_worker_command = "python manage.py celery worker"
celery_worker_options = {
  "broker" => "amqp://guest:guest@localhost/",
  "concurrency" => 2,
  "queues" => "celery",
  "loglevel" => "INFO"
}.each do |k,v|
  celery_worker_command = celery_worker_command + "--#{k}=#{v}"
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

celery_beat_command = "python manage.py celery beat"
celery_beat_options = {
  "broker" => "amqp://guest:guest@localhost/",
  "pidfile" => "/var/run/celery/celery-beat.pid",
  "schedule" => "/var/lib/celery/celerybeat-schedule",
  "loglevel" => "INFO"
}.each do |k,v|
  celery_beat_command = celery_beat_command + "--#{k}=#{v}"
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

