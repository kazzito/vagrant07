#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "git" do
  action [ :install, :upgrade ]
end

package "ncurses-devel" do
  action [ :install, :upgrade ]
end

bash 'install_sl' do
  not_if { File.exists?("/usr/local/bin/sl") }
  user 'root'
  cwd '/tmp'
  code <<-EOH
    git clone https://github.com/gmkou/sl.git
    cd sl
    make
    mv /tmp/sl/sl /usr/local/bin/sl
  EOH
end