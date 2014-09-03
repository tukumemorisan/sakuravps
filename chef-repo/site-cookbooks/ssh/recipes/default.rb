#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

service "sshd" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end

template "sshd_config" do
    path "/etc/ssh/sshd_config"
    source "sshd_config.erb"
    mode 0600
    notifies :reload, "service[sshd]"
end

template "i18n" do
    path "/etc/sysconfig/i18n"
    source "i18n.erb"
    mode 0644
end

users = data_bag("account")
users.each do |id|
u = data_bag_item("account",id)

    directory "/home/#{u["name"]}/.ssh" do
        owner u["name"]
        group u["name"]
        recursive true
        mode 0700
        action :create
    end

    template "authorized_keys" do
        path "/home/#{u["name"]}/.ssh/authorized_keys"
        source "authorized_keys.erb"
        owner u["name"]
        group u["name"]
        mode 0600
        action :create_if_missing
    end
end