#
# Cookbook Name:: twoscoops
# Recipe:: test
#
# Copyright 2013, BNOTIONS
#
# All rights reserved - Do Not Redistribute
#

include_recipe "twoscoops::local"

execute "pip-install-test-requirements" do
  cwd "/vagrant"
  command "pip install -r requirements/test.txt"
end

execute "django-jenkins" do
  cwd "/vagrant/#{node['twoscoops']['project_name']}"
  command "./manage.py jenkins --settings=#{node['twoscoops']['project_name']}.settings.test"
end
