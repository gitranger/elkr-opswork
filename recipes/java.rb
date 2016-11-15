#
# Cookbook Name:: elkr
# Recipe:: java
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

%w[ java-1.8.0-openjdk.x86_64 ].each do |pkgs|
  yum_package pkgs do
     action :install
  end
end

