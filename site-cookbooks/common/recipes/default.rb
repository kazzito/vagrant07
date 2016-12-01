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
