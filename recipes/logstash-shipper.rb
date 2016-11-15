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


%w[ java-1.8.0-openjdk.x86_64 logstash ].each do |pkgs|
  yum_package pkgs do
     action :install
  end
end

service "logstash" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

#redis=search(:nodes_info, "id:redis").first
redis = search("aws_opsworks_instance", "hostname:redis-01").first
template "/etc/logstash/conf.d/logstash.conf" do 
  source "logstash.shipper.conf.erb" 
  variables(
    :redis_host => "#{redis['private_ip']}" ,
    :redis_port => "6379"
  )
  notifies :restart, "service[logstash]", :immediately
end
