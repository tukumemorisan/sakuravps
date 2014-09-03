#
# Cookbook Name:: mysqlset
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

mysql_connection_info = {
  :host     => "localhost",
  :username => "root",
  :password => node["mysql"]["server_root_password"]
}

#postfixadmin db
mysql_database node["mailset"]["postfixadmindbname"] do
  connection mysql_connection_info
  action :create
end

#mysql user
dbuser = data_bag_item("dbuser","webmaster")
mysql_database_user dbuser["name"] do
  connection mysql_connection_info
  password dbuser["password"]
  action :grant
end

#postfixadmin mysql user
mysql_database_user node["mailset"]["postfixadmindbuser"] do
  connection mysql_connection_info
  database_name node["mailset"]["postfixadmindbname"]
  password node["mailset"]["postfixadmindbpasswd"]
  action :grant
end

template '/etc/mysql/conf.d/mysite.cnf' do
  owner "mysql"
  group "mysql"
  notifies :restart, "mysql_service[default]"
end