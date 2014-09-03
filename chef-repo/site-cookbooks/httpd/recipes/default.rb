#
# Cookbook Name:: httpd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

yum_package "yum-fastestmirror" do
  action :install
end

execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

package "httpd" do
  action :install
end

service "httpd" do
  supports :restart => true
  action [ :enable , :start ]
end

template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd.conf.erb"
  mode 0644
  notifies :restart, "service[httpd]"
end

s = []
data_ids = data_bag("sites")
data_ids.each do |site|
  s.push(data_bag_item("sites",site)["id"])
end
u = data_bag_item("account","webmaster")

template "vhosts.conf" do
  path "/etc/httpd/conf.d/vhosts.conf"
  source "vhosts.conf.erb"
  mode 0644
  variables({
     :sites => s
  })
  notifies :restart, "service[httpd]"
end

data_ids.each do |site|
s = data_bag_item("sites",site)
  directory "/var/www/html/#{s["id"]}" do
    owner u["name"]
    group "apache"
    mode 0755
    action :create
  end
end

execute "chown" do
    command "chown -R #{u["name"]}.apache /var/www/html"
    action :run
end