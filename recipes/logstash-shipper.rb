#
# Cookbook Name:: elkr
# Recipe:: logstash-shipper
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

cookbook_file "/etc/yum.repos.d/logstash.repo" do 
  source "logstash.repo" 
end

bash 'add logstash repository' do
  user 'root'
  code <<-EOH
    rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
  EOH
end

include_recipe 'elkr::java'
%w[ logstash ].each do |pkgs|
  yum_package pkgs do
     action :install
  end
end

service "logstash" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

%w[ /etc/logstash/keystore_pass /etc/logstash/keystore.jks ].each do |keydb|
  keyfile = "#{keydb}".split('/').last
  cookbook_file "#{keydb}" do 
    source "#{keyfile}" 
  end
end

role_name = "#{node[:elkr][:layer][:redis][:short_name]}"
redis = search("aws_opsworks_instance", "role:#{role_name}").first

template "/etc/logstash/conf.d/logstash.conf" do 
  source "logstash.shipper.conf.erb" 
  variables(
    :redis_host => "#{redis['private_ip']}" ,
    :redis_port => "6379"
  )
  notifies :restart, "service[logstash]", :immediately
end

# nginx reverse proxy
node.default['nginx']['proxy']  = "logstash"
include_recipe 'elkr::nginx'







