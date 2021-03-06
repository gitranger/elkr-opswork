#
# Cookbook Name:: elkr
# Recipe:: kibana
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'elkr::java'

cookbook_file "/etc/yum.repos.d/logstash.repo" do 
  source "logstash.repo" 
end

bash 'add logstash repository' do
  user 'root'
  code <<-EOH
    rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
  EOH
end


%w[ kibana ].each do |pkgs|
  yum_package pkgs do
     action :install
  end
end

service "kibana" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

role_name = "#{node[:elkr][:layer][:elasticsearch][:short_name]}"
elastic = search("aws_opsworks_instance", "role:#{role_name}").first

Chef::Log.info("********** The instance private_ip is '#{elastic['private_ip']}' **********")
template "/etc/kibana/kibana.yml" do 
  source "kibana.yml.erb" 
  variables(
    :host => "#{elastic[:private_ip]}"
  )
  notifies :restart, "service[kibana]", :immediately
end

# nginx reverse proxy
node.default['nginx']['proxy']  = "kibana"
node.default['nginx']['basic_auth'] = "true"
include_recipe 'elkr::nginx'







