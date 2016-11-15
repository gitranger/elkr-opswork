#
# Cookbook Name:: elkr
# Recipe:: redis
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

yum_package 'epel-release' do
     action :install
     flush_cache( { :after => true } )
end

yum_package 'redis' do
    action :install
end

service "redis" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/etc/redis.conf" do 
  source "redis.conf.erb" 
  notifies :restart, "service[redis]", :immediately
end

