#
# Cookbook Name:: elkr
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


node.default['tz'] = "Asia/Bangkok"
node.default['ntp']['servers'] = [
    '0.pool.ntp.org',
    '1.pool.ntp.org',
    '2.pool.ntp.org',
    '3.pool.ntp.org'
]
include_recipe 'selinux::permissive'
execute "timedatectl --no-ask-password set-timezone #{node[:tz]}"
include_recipe 'ntp::default'
#include_recipe 'elkr::firewall'
#include_recipe 'elkr::web_user'
#include_recipe 'elkr::web'
#include_recipe 'elkr::elk'
#include_recipe 'elkr::debug'
