#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#{}%W{ php php-devel php-pear php-mbstring php-xml php-mcrypt php-gd php-pecl-xdebug php-opcache php-pecl-apcu php-fpm php-phpunit-PHPUnit php-mysqlnd }.each do |pkg|
#  package "#{pkg}" do
#    action [ :install, :upgrade ]
#    option '--enablerepo=remi,remi-php56'
#  end
#end

#package "php" do
#  action [ :install, :upgrade ]
#  options "--enablerepo=remi,remi-php56"
#end

%w{php php-devel php-pear php-mbstring php-xml php-mcrypt php-gd php-pecl-xdebug php-opcache php-pecl-apcu php-phpunit-PHPUnit php-mysqlnd}.each do |pkg|
  package pkg do
    action [ :install, :upgrade ]
    options "--enablerepo=remi,remi-php56"
  end
end

bash "backup php.ini" do
  code <<-EOC
    cp -p /etc/php.ini /etc/php.ini.org.`date "+%Y%m%d_%H%M%S"`
  EOC
end

template "php.ini" do
  path "/etc/php.ini"
  source "php.ini.erb"
end

service "httpd" do
  action [ :restart ]
end
