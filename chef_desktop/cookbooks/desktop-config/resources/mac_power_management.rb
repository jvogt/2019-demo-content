# frozen_string_literal: true

provides :mac_power_management
description 'Use this resource to set the power settings of a kiosk-style device when you need it always-on'

property :computer_sleep_time, String, default: 'never', description: 'A time value between 1-60 minutes or "never" to use to set the computer to sleep after. Defaults to never'
property :display_sleep_time, String, default: 'never', description: 'A time value between 1-60 minutes or "never" to use to set the display to sleep after. Defaults to never'
property :disk_sleep_time, String, default: 'never', description: 'A time value between 1-60 minutes or "never" to use to set the hard disk to sleep after. Defaults to never'

provides :mac_power_management, platform: 'mac_os_x'

load_current_value do
  computer_sleep_time timer_value('getcomputersleep')
  display_sleep_time timer_value('getdisplaysleep')
  disk_sleep_time timer_value('getharddisksleep')
end

def timer_value(setting)
  cmd = "/usr/sbin/systemsetup -#{setting}"
  shell_out(cmd).stdout.to_s.split(' ')[2].downcase
end

action :set do
  converge_if_changed :computer_sleep_time do
    execute 'set computer to sleep never' do
      command "/usr/sbin/systemsetup -setcomputersleep #{new_resource.computer_sleep_time}"
      user 'root'
    end
  end

  converge_if_changed :display_sleep_time do
    execute 'set display to sleep never' do
      command "/usr/sbin/systemsetup -setdisplaysleep #{new_resource.display_sleep_time}"
      user 'root'
    end
  end

  converge_if_changed :disk_sleep_time do
    execute 'set disk to sleep never' do
      command "/usr/sbin/systemsetup -setharddisksleep #{new_resource.disk_sleep_time}"
      user 'root'
    end
  end
end
