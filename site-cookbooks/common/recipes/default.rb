#
# Cookbook Name:: common
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "set_localtime" do
  code <<-EOC
    cp /usr/share/zoneinfo/Japan /etc/localtime
    echo ZONE="Asia/Tokyo" > /etc/sysconfig/clock
  EOC
  not_if "strings /etc/localtime | grep 'JST'"
end

bash "set_log_permission" do
  code <<-EOC
    chmod -R 777 /var/log/
  EOC
end

bash "selinux_off" do
  code <<-EOC
    setenforce 0
  EOC
  not_if "getenforce | grep 'Disabled'"
end

template "selinux_config" do
  path "/etc/selinux/config"
  source "selinux_config.erb"
  not_if "cat /etc/selinux/config | grep 'SELINUX=disabled'"
end
