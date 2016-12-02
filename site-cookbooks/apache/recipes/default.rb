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


bash "backup httpd.conf" do
  code <<-EOC
    cp -p /etc/httpd/conf/httpd.conf /tmp/httpd.conf.`date "+%Y%m%d_%H%M%S"`
  EOC
end

template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd.conf.erb"
end

bash "backup janus.conf" do
  code <<-EOC
    cp -p /etc/httpd/conf.d/janus.conf /tmp/janus.conf.`date "+%Y%m%d_%H%M%S"`
  EOC
  only_if { File.exists?("/etc/httpd/conf.d/janus.conf") }
end

template "janus.conf" do
  path "/etc/httpd/conf.d/janus.conf"
  source "janus.conf.erb"
  #not_if { File.exists?("/etc/httpd/conf.d/janus.conf") }
end

service "httpd" do
  action [ :enable, :start ]
end
