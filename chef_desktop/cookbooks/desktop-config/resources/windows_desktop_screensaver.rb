# frozen_string_literal: true

provides :windows_desktop_screensaver
description 'A resource for configuring a secure screensaver'

unified_mode true

property :screensaver_name, String, description: 'The name of a specific or custom screensaver to enable.'
property :require_password, [true, false], default: true, description: 'Require a password when waking from the screensaver.'
property :idle_time, Integer, default: 20, description: 'The amount of idle time in minutes before the screensaver comes on.'
property :allow_lower_user_idle_time, [true, false], default: false, description: 'Allow users to set their screen saver idle time lower than the system requirements.'

provides :desktop_screensaver, platform: 'windows'

def screensaver_selected?(key)
  powershell_exec(<<-CODE).result
    $local_result = Get-ItemProperty -Path "HKCU:\\Control Panel\\Desktop" | Select-Object -ExpandProperty #{key}
    if ($local_result -eq $null){
      $local_result = "0"
    }
    return $local_result
  CODE
end

action :enable do
  timeout = new_resource.idle_time * 60

  reg_current = screensaver_selected?('scrnsave.exe')

  screensaver_name = reg_current.nil? || reg_current == '0' ? new_resource.screensaver_name : reg_current

  if new_resource.allow_lower_user_idle_time == true
    current_timeout = powershell_exec(<<-CODE).result
      Get-ItemProperty -Path "HKCU:\\Control Panel\\Desktop" | Select-Object -ExpandProperty ScreenSaveTimeOut
    CODE

    timeout = (current_timeout > timeout.to_s) ? timeout.to_s : current_timeout

    if registry_value_exists?('HKCU\\Software\\Policies\\Microsoft\\Windows\\Control Panel\\Desktop', { name: 'ScreenSaveTimeOut' }, :x86_64)
      registry_key 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop' do
        recursive true
        values [{
          name: 'ScreenSaveTimeOut',
          type: :string,
          data: '',
          }]
        action :delete
      end

      registry_key 'HKCU\Control Panel\Desktop' do
        recursive true
        values [{
          name: 'ScreenSaveTimeOut',
          type: :string,
          data: timeout,
        }]
        action :create
      end
    end

    registry_key 'HKCU\Control Panel\Desktop' do
      recursive true
      values [{
        name: 'ScreenSaveTimeOut',
        type: :string,
        data: timeout,
      }]
      action :create
    end
  end

  registry_key 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop' do
    recursive true
    values [{
      name: 'ScreenSaveTimeOut',
      type: :string,
      data: timeout,
      }]
    action :create
  end

  registry_key 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop' do
    recursive true
    values [
      {
        name: 'ScreenSaveActive',
        type: :string,
        data: 1,
      },
      {
        name: 'ScreensaverIsSecure',
        type: :string,
        data: new_resource.require_password ? 1 : 0,
      }]
    action :create
  end

  registry_key 'HKCU\Control Panel\Desktop' do
    values [{
      name: 'scrnsave.exe',
      type: :string,
      data: screensaver_name,
    }]
    action :create
  end
end

action :disable do
  registry_key 'HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop' do
    recursive true
    values [{
      name: 'ScreenSaveActive',
      type: :string,
      data: 0,
      }]
  end
end
