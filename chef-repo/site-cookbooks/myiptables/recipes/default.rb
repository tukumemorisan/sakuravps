#
# Cookbook Name:: myiptables
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

simple_iptables_policy "INPUT" do
  policy "DROP"
end

simple_iptables_rule "system" do
  rule [
         "--in-interface lo",
         "-m conntrack --ctstate ESTABLISHED,RELATED",
         "--proto tcp --dport #{node["ssh"]["port"]}",
       ]
  jump "ACCEPT"
end

simple_iptables_rule "http" do
  rule [ "--proto tcp --dport 80",
         "--proto tcp --dport 443" ]
  jump "ACCEPT"
end

simple_iptables_rule "mail" do
  rule [
         "--proto tcp --dport 25",
         "--proto tcp --dport 110",
         "--proto tcp --dport 143",
         "--proto tcp --dport 587"
       ]
  jump "ACCEPT"
end