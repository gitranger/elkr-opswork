#
# Cookbook Name:: elkr
# Recipe:: nginx
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

yum_package 'epel-release' do
   action :install
end

yum_package 'nginx' do
   action :install
end

service "nginx" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
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


Chef::Log.info("********** The instance private_ip is '#{elastic['private_ip']}' **********")
template "/etc/kibana/kibana.yml" do
  source "kibana.yml.erb"
  variables(
    :host => "#{elastic[:private_ip]}"
  )
  notifies :restart, "service[kibana]", :immediately
end






