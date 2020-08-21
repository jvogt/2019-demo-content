# frozen_string_literal: true

provides :mac_chef_schedule
description 'A resource for configuring the Chef Infra Client to run on a schedule'

unified_mode true

property :running_interval, Integer, default: 30, description: 'Time in minutes between Chef Infra Client executions'
property :start_time, String, description: 'A time expressed in a 24 hour clock type. Used for a runonce execution'

provides :chef_schedule, platform: 'mac_os_x'

action :enable do
  template '/Library/LaunchDaemons/com.chef.chef-client.plist' do
    cookbook 'desktop-config'
    source 'com.chef.chef-client.plist.erb'
    owner 'root'
    group 'wheel'
    mode '0644' # was 0755
    variables(
      interval: new_resource.running_interval * 60
    )
  end

  service 'chef-client' do
    service_name 'com.chef.chef-client'
    provider Chef::Provider::Service::Macosx
    action :start
  end
end

action :runonce do
  time_hash = new_resource.start_time.split(':')
  cron 'Run Chef-Client once' do
    hour time_hash[0]
    minute time_hash[1]
    command 'chef-client'
    user 'root'
  end
end

action :disable do
  service 'chef-client' do
    service_name 'com.chef.chef-client'
    provider Chef::Provider::Service::Macosx
    action :disable
  end
end
