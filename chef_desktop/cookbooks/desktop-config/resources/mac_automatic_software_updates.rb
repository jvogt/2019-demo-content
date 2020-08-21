# frozen_string_literal: true

provides :automatic_software_updates
description 'A Microsoft produced resource for updating the OS'

property :check, [true, false], description: 'Tell the OS to check for updates'
property :download, [true, false], description: 'Tell the OS to download updates'
property :install_os, [true, false], description: 'Set to update the OS'
property :install_app_store, [true, false], description: 'Set this to add app updates'
property :install_critical, [true, false], description: 'Set this to install critical updates'

software_update_plist = '/Library/Preferences/com.apple.SoftwareUpdate.plist'
app_store_plist = '/Library/Preferences/com.apple.commerce.plist'

provides :automatic_software_updates, platform: 'mac_os_x'

action :set do
  if !new_resource.check && new_resource.download
    raise "Downloads cannot continue as 'check' is set to false"
  end

  unless new_resource.download
    if new_resource.install_os || new_resource.install_app_store
      raise "OS or App Store updates cannot be enabled if 'download' is false"
    end
  end

  plist 'entry for AutomaticCheckEnabled' do
    entry 'AutomaticCheckEnabled'
    value new_resource.check
    path software_update_plist
  end

  plist 'entry for AutomaticDownload' do
    entry 'AutomaticDownload'
    value new_resource.download
    path software_update_plist
  end

  plist 'entry for CriticalUpdateInstall' do
    entry 'CriticalUpdateInstall'
    value new_resource.install_critical
    path software_update_plist
  end

  plist 'entry for AutomaticallyInstallMacOSUpdates' do
    entry 'AutomaticallyInstallMacOSUpdates'
    value new_resource.install_os
    path software_update_plist
  end

  template '/Library/Preferences/com.apple.commerce.plist' do
    cookbook 'desktop-config'
    source 'com.apple.commerce.plist.erb'
    owner 'root'
    group 'wheel'
    mode '0755'
    action :create_if_missing # ::File.exist?('/Library/Preferences/com.apple.commerce.plist')
  end

  plist 'entry for AutoUpdate' do
    entry 'AutoUpdate'
    value new_resource.install_app_store
    path app_store_plist
  end
end
