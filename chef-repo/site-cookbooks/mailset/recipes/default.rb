#
# Cookbook Name:: mailset
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

u = data_bag_item("account","webmaster")
mail = data_bag_item("mail","vuser")

%w{postfix dovecot dovecot-mysql cyrus-sasl}.each do |pkg|
    package pkg do
        action :install
    end
end

service "sendmail" do
  action [ :disable, :stop ]
end

service "postfix" do
  supports :restart => true, :start => true
  action :enable
end

service "dovecot" do
  supports :restart => true, :start => true
  action :enable
end

execute "home_chmod" do
  command "chmod 771 /home/#{mail["name"]}"
  action :nothing
end

group mail["name"] do
    gid mail["gid"]
    action :create
end

user mail["name"] do
    shell "/sbin/nologin"
    gid mail["gid"]
    uid mail["uid"]
    home "/home/#{mail["name"]}"
    password mail["password"]
    supports :manage_home => true
    action :create
    notifies :run ,"execute[home_chmod]"
end

template "main.cf" do
  path "/etc/postfix/main.cf"
  source "main.cf.erb"
  mode 0644
  notifies :restart, "service[postfix]"
  variables({
     :gid => mail["gid"],
     :uid => mail["uid"]
  })
end

template "master.cf" do
  path "/etc/postfix/master.cf"
  source "master.cf.erb"
  mode 0644
  notifies :restart, "service[postfix]"
end

template "mysql_virtual_alias_maps.cf" do
  path "/etc/postfix/mysql_virtual_alias_maps.cf"
  source "mysql_virtual_alias_maps.cf.erb"
  mode 0644
  notifies :restart, "service[postfix]"
end

template "mysql_virtual_domains_maps.cf" do
  path "/etc/postfix/mysql_virtual_domains_maps.cf"
  source "mysql_virtual_domains_maps.cf.erb"
  mode 0644
  notifies :restart, "service[postfix]"
end

template "mysql_virtual_mailbox_maps.cf" do
  path "/etc/postfix/mysql_virtual_mailbox_maps.cf"
  source "mysql_virtual_mailbox_maps.cf.erb"
  mode 0644
  notifies :restart, "service[postfix]"
end

template "mysql_virtual_mailbox_limit_maps.cf" do
  path "/etc/postfix/mysql_virtual_mailbox_limit_maps.cf"
  source "mysql_virtual_mailbox_limit_maps.cf.erb"
  mode 0644
  notifies :restart, "service[postfix]"
end

template "dovecot-mysql.conf" do
  path "/etc/dovecot/dovecot-mysql.conf"
  source "dovecot-mysql.conf.erb"
  mode 0644
  notifies :restart, "service[dovecot]"
  variables({
   :gid => mail["gid"],
   :uid => mail["uid"]
})
end

template "dovecot.conf" do
  path "/etc/dovecot/dovecot.conf"
  source "dovecot.conf.erb"
  mode 0644
  notifies :restart, "service[dovecot]"
end

template "10-mail.conf" do
  path "/etc/dovecot/conf.d/10-mail.conf"
  source "10-mail.conf.erb"
  mode 0644
  notifies :restart, "service[dovecot]"
  variables({
     :gid => mail["gid"],
     :uid => mail["uid"]
  })
end

template "20-pop3.conf" do
  path "/etc/dovecot/conf.d/20-pop3.conf"
  source "20-pop3.conf.erb"
  mode 0644
  notifies :restart, "service[dovecot]"
end

template "10-auth.conf" do
  path "/etc/dovecot/conf.d/10-auth.conf"
  source "10-auth.conf.erb"
  mode 0644
  notifies :restart, "service[dovecot]"
end

template "10-master.conf" do
  path "/etc/dovecot/conf.d/10-master.conf"
  source "10-master.conf.erb"
  mode 0644
  notifies :restart, "service[dovecot]"
end

template "auth-mysql.conf.ext" do
  path "/etc/dovecot/conf.d/auth-mysql.conf.ext"
  source "auth-mysql.conf.ext.erb"
  mode 0644
  notifies :restart, "service[dovecot]"
end

execute "postfixadmin" do
  command <<-EOH
  wget http://downloads.sourceforge.net/project/postfixadmin/postfixadmin/postfixadmin-2.91/postfixadmin-2.91.tar.gz
  tar xzf postfixadmin-2.91.tar.gz
  mv postfixadmin-2.91 #{node["mailset"]["postfixadmindir"]}
  chown -R #{u["name"]}.apache #{node["mailset"]["postfixadmindir"]}
  chmod 755 #{node["mailset"]["postfixadmindir"]}
  chmod 775 #{node["mailset"]["postfixadmindir"]}/templates_c
  rm -f postfixadmin-2.91.tar.gz
  EOH
  action :run
  notifies :create, "template[config.inc.php]"
  notifies :create, "template[backup.php]"
  notifies :create, "template[htaccess]"
  notifies :create, "template[htpasswd]"
end

template "config.inc.php" do
  path "#{node["mailset"]["postfixadmindir"]}/config.inc.php"
  source "config.inc.php.erb"
  mode 0644
  action :nothing
end

template "backup.php" do
  path "#{node["mailset"]["postfixadmindir"]}/backup.php"
  source "backup.php.erb"
  mode 0644
  action :nothing
end

template "htaccess" do
  path "#{node["mailset"]["postfixadmindir"]}/.htaccess"
  source "htaccess.erb"
  mode 0644
  owner u["name"]
  group "apache"
  action :nothing
end

template "htpasswd" do
  path "#{node["mailset"]["postfixadmindir"]}/.htpasswd"
  source "htpasswd.erb"
  mode 0644
  owner u["name"]
  group "apache"
  action :nothing
end