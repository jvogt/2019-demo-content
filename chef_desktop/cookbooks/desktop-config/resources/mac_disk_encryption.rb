# frozen_string_literal: true

provides :mac_disk_encryption
description 'Use this resource to enforce FileVault encryption on nodes'

provides :disk_encryption, platform: 'mac_os_x'

unified_mode true

action :enable do
  directory '/private/var/chef' do
    owner 'root'
    group 'wheel'
    mode '0755'
    action :create
  end

  execute 'turn on FileVault and capture the key' do
    command 'fdesetup enable -defer /private/var/chef/recovery.plist -forceatlogin 0 –dontaskatlogout'
    user 'root'
    action :run
  end
end