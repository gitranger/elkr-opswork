#
# Cookbook Name:: elkr
# Recipe:: elk
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


%w[ java-1.8.0-openjdk.x86_64 elasticsearch ].each do |pkgs|
  yum_package pkgs do
     action :install
  end
end

service "elasticsearch" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

template "/etc/sysctl.d/99-sysctl.conf" do 
  source "99-sysctl.conf.erb" 
end

bash 'elasticsearch prerequisite' do
  user 'root'
  code <<-EOH
    sysctl  -w vm.max_map_count=262144 
  EOH
end

template "/etc/elasticsearch/elasticsearch.yml" do 
  source "elasticsearch.yml.erb" 
  notifies :restart, "service[elasticsearch]", :immediately
end

