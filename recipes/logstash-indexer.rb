#
# Cookbook Name:: elkr
# Recipe:: logstash-indexer
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
#elastic=search(:nodes_info, "id:elasticsearch").first
redis = search("aws_opsworks_instance", "hostname:redis-01").first
elastic = search("aws_opsworks_instance", "hostname:elasticsearch-01").first
template "/etc/logstash/conf.d/logstash.conf" do 
  source "logstash.indexer.conf.erb" 
  variables(
    :redis_host => "#{redis['private_ip']}",
    :redis_port => "6379",
    :elastic_host => "#{elastic['private_ip']}",
    :elastic_port => "9200"
  )
  notifies :restart, "service[logstash]", :immediately
end

