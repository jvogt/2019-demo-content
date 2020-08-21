# frozen_string_literal: true

provides :windows_automatic_logout
description 'A resource to help lockout and secure the firewall, AV, and other services'

unified_mode true

property :autologout, [true, false], default: true, description: 'Enable the system to logout because of inactivity'
property :autologout_time, Integer, default: 3600, description: 'The amount of time in seconds to elapse before logging the system out. Defaults to 1 hour'

provides :automatic_logout, platform: 'windows'

action :set do
  if new_resource.autologout
    registry_key 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' do
      recursive true
      values [{
        name: 'InactivityTimeoutSecs',
        type: :dword,
        data: new_resource.autologout_time,
      }]
      action :create
    end
  end
end
