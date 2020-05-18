#
# Cookbook:: hpe_acme_app_1
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

windows_feature ['iis-webserver'] do
  action :install
  all true
end
