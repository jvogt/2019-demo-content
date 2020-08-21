#
# Cookbook:: acme_base
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apt_update

include_recipe 'chef-client::default'
include_recipe 'os-hardening'
include_recipe 'audit::default'

# package 'telnet' do
#   action :install
# end

# package 'ntp' do
#   action :install
# end

# service 'ntpd' do
#   action [:enable, :start]
# end

