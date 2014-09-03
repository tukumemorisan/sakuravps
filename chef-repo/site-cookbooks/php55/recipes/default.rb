#
# Cookbook Name:: php55
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/#{node["remi"]["file_name"]}" do
  source "#{node["remi"]["remote_uri"]}"
  not_if { ::File.exists?("/tmp/#{node["remi"]["file_name"]}") }
end

package node["remi"]["file_name"] do
  action :install
  provider Chef::Provider::Package::Rpm
  source "/tmp/#{node["remi"]["file_name"]}"
end

%w{php php-xml php-pdo php-imap php-gd php-devel php-mbstring php-mcrypt php-mysql php-phpunit-PHPUnit php-pecl-xdebug}.each do |p|
  package p do
    action :install
    options "--enablerepo=remi --enablerepo=remi-php55"
  end
end

template "php.ini" do
  path "/etc/php.ini"
  source "php.ini.erb"
  mode 0644
  notifies :restart, "service[httpd]"
end