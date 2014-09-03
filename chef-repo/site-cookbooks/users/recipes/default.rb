#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#root rootmodify
user "root" do
    password "$1$11R8tu9P$Mf5AcbOH7Yt.d6eCLWWvc1"
    action :modify
end

#userを追加
users = data_bag("account")
users.each do |id|
u = data_bag_item("account",id)
    user u["name"] do
        password u["password"]
        home "/home/#{u["name"]}"
        supports :manage_home => true
        action :create
    end
    #groupを作成
    group u["group"] do
        members u["name"]
        action :create
    end
end

#sudo用にwheelを追加
webmaster = data_bag_item("account","webmaster")
group "wheel" do
    members webmaster["name"]
    action :create
end
