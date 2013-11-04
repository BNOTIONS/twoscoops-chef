#
# Cookbook Name:: twoscoops
# Recipe:: database
#
# Copyright 2013, BNOTIONS
#
# All rights reserved - Do Not Redistribute
#

if node['twoscoops']['database']['engine'] == 'django.db.backends.postgresql_psycopg2'
  include_recipe "database::postgresql"

  database_connection_info = {
    :host => node['twoscoops']['database']['host'],
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres']
  }

  template "#{node['twoscoops']['application_path']}/#{node['twoscoops']['project_name']}/#{node['twoscoops']['project_name']}/settings/database.py" do
    source "database.py.erb"
    mode 00644
    only_if { node['twoscoops']['application_revision'].nil? }
  end

  postgresql_database node['twoscoops']['application_name'] do
    connection database_connection_info
    provider Chef::Provider::Database::Postgresql
    action :create
  end

  postgresql_database_user node['twoscoops']['database']['username'] do
    connection database_connection_info
    password node['twoscoops']['database']['password']
    action :create
  end

  postgresql_database_user node['twoscoops']['database']['username'] do
    connection database_connection_info
    database_name node['twoscoops']['application_name']
    privileges [:all]
    action :grant
  end
end
