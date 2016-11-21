#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# add mysql yum repository
remote_file "#{Chef::Config[:file_cache_path]}/mysql57-community-release-el6-7.noarch.rpm" do
  source 'http://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm'
  action :create
end

rpm_package "mysql-community-release" do
  source "#{Chef::Config[:file_cache_path]}/mysql57-community-release-el6-7.noarch.rpm"
  action :install
end

# install mysql community server
yum_package "mysql-community-server" do
  action :install
  version "5.7.16-1.el6"
  flush_cache [:before]
end

bash "skip-grant-tables" do
  code <<-EOC
    echo "skip-grant-tables" >> /etc/my.cnf
  EOC
  not_if "cat /etc/my.cnf | grep 'skip-grant-tables'"
end

service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :restart ]
end

=begin

# secure install
root_password = node["mysql"]["root_password"]
execute "secure_install" do
  command "/usr/bin/mysql -u root < #{chef::config[:file_cache_path]}/secure_install.sql"
  action :nothing
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template "#{chef::config[:file_cache_path]}/secure_install.sql" do
  owner "root"
  group "root"
  mode 0644
  source "secure_install.sql.erb"
  variables({
    :root_password => root_password,
  })
  notifies :run, "execute[secure_install]", :immediately
end

# create database
db_name = node["mysql"]["db_name"]
execute "create_db" do
  command "/usr/bin/mysql -u root -p#{root_password} < #{chef::config[:file_cache_path]}/create_db.sql"
  action :nothing
  not_if "/usr/bin/mysql -u root -p#{root_password} -D #{db_name}"
end

template "#{chef::config[:file_cache_path]}/create_db.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_db.sql.erb"
  variables({
    :db_name => db_name,
  })
  notifies :run, "execute[create_db]", :immediately
end

# create user
user_name     = node["mysql"]["user"]["name"]
user_password = node["mysql"]["user"]["password"]
execute "create_user" do
  command "/usr/bin/mysql -u root -p#{root_password} < #{chef::config[:file_cache_path]}/create_user.sql"
  action :nothing
  not_if "/usr/bin/mysql -u #{user_name} -p#{user_password} -D #{db_name}"
end

template "#{chef::config[:file_cache_path]}/create_user.sql" do
  owner "root"
  group "root"
  mode 0644
  source "create_user.sql.erb"
  variables({
    :db_name => db_name,
    :username => user_name,
    :password => user_password,
  })
  notifies :run, "execute[create_user]", :immediately
end

=end