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

