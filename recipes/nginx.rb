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

case node['nginx']['proxy']
when 'kibana'
  template "/etc/nginx/nginx.conf" do
    source "nginx.conf.proxy.erb"
    variables(
      :host => "localhost",
      :port => "5601"
    )
    notifies :restart, "service[nginx]", :immediately
  end
when 'logstash'
  template "/etc/nginx/nginx.conf" do
    source "nginx.conf.proxy.erb"
    variables(
      :host => "localhost",
      :port => "8080"
    )
    notifies :restart, "service[nginx]", :immediately
  end
end







