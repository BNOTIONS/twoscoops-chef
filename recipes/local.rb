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
include_recpie "celery"
include_recpie "supervisor"
include_recpie "supervisord"

#user "celery"

#directory "/var/run/celery" do
#  owner "celery"
#end

#directory "/var/lib/celery" do
#  owner "celery"
#end

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

celery_worker_options = {
  "broker" => "amqp://guest:guest@localhost/",
  "concurrency" => 2,
  "queues" => "celery"
}

celery_worker "#{node['twoscoops']['project_name']}" do
  user "celery"
  django "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  logfile "#{node['twoscoops']['application_path']}/logs/celery-worker.log"
  options celery_worker_options
end

celery_beat_options = {
  "broker" => "amqp://guest:guest@localhost/"
}

celery_beat "#{node['twoscoops']['project_name']}" do
  user "celery"
  django "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
  logfile "#{node['twoscoops']['application_path']}/logs/celery-beat.log"
  options celery_beat_options
end


#supervisor_service "celeryd" do
#  command "python manage.py celeryd --loglevel=INFO"
#  user "celery"
#  autostart true
#  directory "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
#  stdout_logfile "#{node['twoscoops']['application_path']}/logs/celeryd.log"
#  stderr_logfile "#{node['twoscoops']['application_path']}/logs/celeryd_error.log"
#  action :enable
#end

#supervisor_service "celery-worker" do
#  command "python manage.py celery worker --loglevel=INFO"
#  user "celery"
#  autostart true
#  directory "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
#  stdout_logfile "#{node['twoscoops']['application_path']}/logs/celery_worker.log"
#  stderr_logfile "#{node['twoscoops']['application_path']}/logs/celery_worker_error.log"
#  action :enable
#end

#supervisor_service "celery-beat" do
#  command "python manage.py celery beat --pidfile=/var/run/celery/celery-beat.pid --schedule=/var/lib/celery/celerybeat-schedule --loglevel=INFO"
#  user "celery"
#  autostart true
#  directory "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}"
#  stdout_logfile "#{node['twoscoops']['application_path']}/logs/celery_beat.log"
#  stderr_logfile "#{node['twoscoops']['application_path']}/logs/celery_beat_error.log"
#  action :enable
#end

