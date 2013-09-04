#
# Cookbook Name:: twoscoops
# Recipe:: local_celery
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rabbitmq"

supervisor_service "celeryd" do
  command "python manage.py celeryd --loglevel=INFO"
  user "nobody"
  autostart true
  directory "/vagrant/#{node['twoscoops']['project_name']}"
  stdout_logfile "/vagrant/logs/celeryd.log"
  stderr_logfile "/vagrant/logs/celeryd.log"
  action :enable
end

supervisor_service "celeryd" do
  command "python manage.py celery worker --loglevel=INFO"
  user "nobody"
  autostart true
  directory "/vagrant/#{node['twoscoops']['project_name']}"
  stdout_logfile "/vagrant/logs/celery_worker.log"
  stderr_logfile "/vagrant/logs/celery_worker_error.log"
  action :enable
end

directory "/var/lib/celery"

supervisor_service "celery-beat" do
  command "python manage.py celery beat --schedule=/var/lib/celery/celerybeat-schedule --loglevel=INFO"
  user "nobody"
  autostart true
  directory "/vagrant/#{node['twoscoops']['project_name']}"
  stdout_logfile "/vagrant/logs/celery_beat.log"
  stderr_logfile "/vagrant/logs/celery_beat_error.log"
  action :enable
end
