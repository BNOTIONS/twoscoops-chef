#
# Cookbook Name:: twoscoops
# Recipe:: test
#
# Copyright 2013, BNOTIONS
#
# All rights reserved - Do Not Redistribute
#

include_recipe "twoscoops::base"
include_recipe "twoscoops::database"

execute "pip-install-test-requirements" do
  cwd "/vagrant"
  command "pip install -r requirements/test.txt"
end

execute "django-jenkins" do
  cwd "/vagrant/#{node['twoscoops']['project_name']}"
  command "./manage.py #{node[:twoscoops][:test][:command]} --traceback"
  environment ({
    "DJANGO_SETTINGS_MODULE" => "#{node['twoscoops']['project_name']}.settings.test"
  })
end
