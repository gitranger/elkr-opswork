#
# Cookbook Name:: elkr
# Recipe:: nginx
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

yum_package 'epel-release' do
   action :install
end

%w[ nginx httpd-tools ].each do |pkg|
  yum_package pkg do
     action :install
  end
end

service "nginx" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

cookbook_file "/etc/nginx/htpasswd" do
  source "htpasswd"
  action :create
end

directory "/etc/nginx/ssl" do
  recursive true
end
%w[ private_key.pem self_cert.pem ].each do |keyfile|
  cookbook_file "/etc/nginx/ssl/#{keyfile}" do
    source "#{keyfile}"
    action :create
  end
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  #variables(
  #  :host => "#{node[:nginx][:server_name]}"
  #)
  notifies :restart, "service[nginx]", :immediately
end






