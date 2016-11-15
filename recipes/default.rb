#
# Cookbook Name:: elkr
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#include_recipe 'elkr::firewall'
#include_recipe 'elkr::debug'

include_recipe 'selinux::permissive'
execute "timedatectl --no-ask-password set-timezone #{node[:tz]}"
include_recipe 'ntp::default'

