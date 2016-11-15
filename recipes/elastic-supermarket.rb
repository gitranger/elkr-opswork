#
# Cookbook Name:: elkr
# Recipe:: elastic-supermarket
#
# Copyright (c) 2016 The Authors, All Rights Reserved.




%w[ java-1.8.0-openjdk.x86_64 ].each do |pkgs|
  yum_package pkgs do
     action :install
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

include_recipe 'elasticsearch::default'

elasticsearch_install 'my_es_installation' do
  type 'package' # type of install
  version "5.0.0"
  action :install # could be :remove as well
end


elasticsearch_configure 'elasticsearch' do
    allocated_memory '2048m'
    configuration ({
      'cluster.name' => 'escluster',
      'node.name' => 'node01',
      'network.host' =>  '0.0.0.0',
      'http.port' => 9202
    })
   notifies :restart, "service[elasticsearch]", :immediately
end

