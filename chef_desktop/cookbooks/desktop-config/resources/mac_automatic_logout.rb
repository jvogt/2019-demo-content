# frozen_string_literal: true

provides :mac_automatic_logout
description 'A resource to help lockout and secure the firewall, AV, and other services'

unified_mode true

property :autologout, [true, false], default: true, description: 'Enable the system to logout because of inactivity'
property :autologout_time, Integer, default: 3600, description: 'The amount of time in seconds to elapse before logging the system out. Defaults to 1 hour'

provides :automatic_logout, platform: 'mac_os_x'

action :set do
  if new_resource.autologout
    macos_userdefaults 'update autologout settings policy' do
      domain '/Library/Preferences/.GlobalPreferences.plist'
      key 'com.apple.autologout.AutoLogOutDelay'
      value new_resource.autologout_time
      type 'integer'
    end
  end
end