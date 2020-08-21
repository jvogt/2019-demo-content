# frozen_string_literal: true

provides :windows_power_management
description 'Use this resource to set the power settings of a kiosk-style device when you need it always-on'

unified_mode true

property :power_scheme_label, String, description: 'A label name to prefix your power scheme with. The code duplicates the existing power scheme to keep it distinct'
property :power_level, String, default: 'balanced', description: 'There are 2 levels of power - balanced, and ultimate.'

provides :windows_power_management, platform: 'windows'

action :set do
  if new_resource.power_level == 'balanced'
    powershell_script 'setting power scheme' do
      code <<-CODE
        $dup = powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e
        $guid = $dup.Split(' ')[3]
        powercfg /changename "$($guid)" "#{new_resource.power_scheme_label} Balanced"
        powercfg /setactive "$($guid)"
        powercfg /change monitor-timeout-ac 15
        powercfg /change disk-timeout-ac 30
        powercfg /change standby-timeout-ac 30
        powercfg /change hibernate-timeout-ac 60
      CODE
    end
  elsif new_resource.power_level == 'ultimate'
    powershell_script 'setting power scheme' do
      code <<-CODE
        $dup = powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        $guid = $dup.Split(' ')[3]
        powercfg /changename "$($guid)" "#{new_resource.power_scheme_label} Ultimate Power"
        powercfg /setactive "$($guid)"
        powercfg /change monitor-timeout-ac 0
        powercfg /change disk-timeout-ac 0
        powercfg /change standby-timeout-ac 0
        powercfg /change hibernate-timeout-ac 0
      CODE
    end
  end
end
