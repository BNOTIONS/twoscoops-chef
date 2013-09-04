#
# Cookbook Name:: twoscoops
# Recipe:: base
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w( git-core libjpeg-dev libfreetype6 libfreetype6-dev zlib1g-dev ).each do |p|
  package p
end
