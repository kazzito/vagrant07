#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "httpd" do
  action [ :install, :upgrade ]
end

template "janus.conf" do
  path "/etc/httpd/conf.d/janus.conf"
  source "janus.conf.erb"
end

service "httpd" do
  action [ :enable, :start ]
end
