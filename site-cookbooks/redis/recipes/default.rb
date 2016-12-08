#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "redis" do
  action [ :install, :upgrade ]
end

service "redis" do
  action [ :enable, :start ]
end
