#
# Cookbook Name:: elkr
# Recipe:: elasticsearch
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
  not_if { File.exist?('/etc/elasticsearch/elasticsearch.yml') }
end

%w[ elasticsearch ].each do |pkgs|
  yum_package pkgs do
     action :install
     not_if { File.exist?('/etc/elasticsearch/elasticsearch.yml') }
  end
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

service "elasticsearch" do
  provider Chef::Provider::Service::Systemd
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

# update configurations
%w[ /etc/elasticsearch/jvm.options /etc/sysconfig/elasticsearch ].each do |elastic_conf|
  esfile =  "#{elastic_conf}".split('/').last 
  template "#{elastic_conf}"  do 
     source "#{esfile}.erb" 
  end
end

# find elasticsearch member ip that will form cluster
role_name = "#{node[:elkr][:layer][:elasticsearch][:short_name]}"
elastic_hosts = search("aws_opsworks_instance", "role:#{role_name}")
es_ips = []
elastic_hosts.each do |instance|
   unless "#{instance[:private_ip]}".to_s.strip.empty?
      es_ip = "\"" +  "#{instance['private_ip']}" + "\"" 
      es_ips << es_ip
   end
end
es_cluster_hosts = es_ips.join(', ')

# find hostname
execute "/bin/hostname > /tmp/hostname"
if File.exist?('/tmp/hostname')
  node_name = File.read('/tmp/hostname').chomp
end

template "/etc/elasticsearch/elasticsearch.yml" do 
  source "elasticsearch.yml.erb" 
  variables(
     :es_cluster_hosts => "#{es_cluster_hosts}",
     :node_name => "#{node_name}"
  )
  notifies :restart, "service[elasticsearch]", :immediately
end

#execute "restart elasticsearch service" do
#  command "touch /tmp/restart_service"
#  notifies :restart, "service[elasticsearch]", :immediately
#end





