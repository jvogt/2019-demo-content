# frozen_string_literal: true

provides :windows_update_settings
description 'Use the `windows_update_settings` resource to manage the various Windows Update patching options.'

unified_mode true

# HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate
property :disable_os_upgrades, [true, false], default: false, description: 'True/False to disable OS upgrades.'
# options: 0 - let windows update update the os - false
#          1 - don't let windows update update the os - true
property :elevate_non_admins, [true, false], default: true, description: 'This property allows normal user accounts to temporarily be elevated to install patches'
# options: 0 - do not elevate a user to force an install - false
#          1 - do elevate the logged on user to install an update - true
property :add_to_target_wsus_group, [true, false], default: false, description: 'If you have a WSUS Server and Target Groups, set this True'
# options: 0 - do not add device to a target wsus group - false
#          1 - please add this device to a target wsus group - true
property :target_wsus_group_name, String, description: 'This is the name of the WSUS Target Group you want the node to be in'
# options: --- a string representing the name of a target group you defined on your wsus server
property :wsus_server_url, String, description: 'The URL of your WSUS server if you use one'
# options: --- a url for your internal update server in the form of https://my.updateserver.tld:4545 or whatever
property :wsus_status_server_url, String, description: 'URL for the WSUS Status server. It can be the same as the URL for the WSUS server itself'
# options: --- a url for your internal wsus status server in the form of https://my.updateserver.tld:4545 or whatever

# HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
property :block_windows_update_website, [true, false], default: false, description: 'Denies access to Windows Update to get updates'
# options: 0 - allow access to the windows update website - false
#          1 - do not allow access to the windows update website - true

# HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU
property :automatic_update_option, Integer, default: 4, description: 'An Integer value to tell nodes when and how to download updates. Default is 4 - Auto-download and schedule updates to install'
# options: 2 - notify before download
#          3 - auto download and notify
#          4 - auto download and schedule - must also set day and time (below)
#          5 - auto update is required and users can configure it
property :automatically_install_minor_updates, [true, false], default: false, description: 'Automatically install minor updates. Default is False'
# options: 0 - do not automatically install minor updates - false
#          1 - of course, silently install them! - true
property :enable_detection_frequency, [true, false], default: false, description: 'Used to override the OS default of how often to check for updates'
# do i want my nodes checking for updates at a time interval i chose?
# options: 0 - do not enable the option for a custom interval - false
#          1 - yeah, buddy, i want to set my own interval for checking for updates - true
property :custom_detection_frequency, Integer, default: 22, description: 'If you decided to override the OS default detection frequency, specify your choice here. Valid choices are 0 - 22'
# a time period of between 0 and 22 hours to check for new updates
# this is a hex value - convert it from dec to hex
property :no_reboot_with_users_logged_on, [true, false], default: true, description: 'Prevents the OS from rebooting while someone is on the console. Default is True'
# options: 0 - user is notified of pending reboot in xx minutes - false/off
#          1 - user is notified of pending reboot but can defer - true/on
property :disable_automatic_updates, [true, false], default: false, description: 'Prevents automatic updates. Defaults to False to allow automatic updates'
# options: 0 - enable automatic updates to the local system - false
#          1 - disable automatic updates - true
property :scheduled_install_day, Integer, default: 0, description: 'A number value to tell Windows when to install updates. Defaults to 0 - every day'
# options: 0 - install every day
#          1-7 day of the week to install, 1 == sunday
property :scheduled_install_hour, Integer, description: 'If you chose a scheduled day to install, then choose an hour on that day for you installation'
# options: --- 2-digit number representing an hour of the day, uses a 24-hour clock, 12 == noon, 24 == midnight
property :update_other_ms_products, [true, false], default: true, description: 'Allows for other Microsoft products to get updates too'
# options: 0 - do not allow wu to update other apps - remove key from hive - false/off
#          1 - please update all my stuff! - true/on
# \AU\AllowMUUpdateService dword: 1
property :use_custom_update_server, [true, false], default: false, description: 'Used to tell nodes to use a WSUS server, Defaults to False - Use Microsoft for updates'
# options: 0 - updates come from from ms - false
#          1 - get updates from wsus server (you'll specify that above) - true

provides :windows_update_settings, platform: 'windows'

action :enable do
  registry_key 'HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\WindowsUpdate' do
    recursive true
    values [{
      name: 'DisableOSUpgrade',
      type: :dword,
      data: new_resource.disable_os_upgrades ? 1 : 0,
    },
    {
      name: 'ElevateNonAdmins',
      type: :dword,
      data: new_resource.elevate_non_admins ? 1 : 0,
    },
    {
      name: 'TargetGroupEnabled',
      type: :dword,
      data: new_resource.add_to_target_wsus_group ? 1 : 0,
    },
    {
      name: 'TargetGroup',
      type: :string,
      data: new_resource.target_wsus_group_name,
    },
    {
      name: 'WUServer',
      type: :string,
      data: new_resource.wsus_server_url,
    },
    {
      name: 'WUStatusServer',
      type: :string,
      data: new_resource.wsus_status_server_url,
    }]
    action :create
  end

  registry_key 'HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer' do
    recursive true
    values [{
      name: 'NoWindowsUpdate',
      type: :dword,
      data: new_resource.block_windows_update_website ? 1 : 0,
    }]
    action :create
  end

  registry_key 'HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\WindowsUpdate\\AU' do
    recursive true
    values [{
      name: 'AUOptions',
      type: :dword,
      data: new_resource.automatic_update_option,
    },
    {
      name: 'AutoInstallMinorUpdates',
      type: :dword,
      data: new_resource.automatically_install_minor_updates ? 1 : 0,
    },
    {
      name: 'DetectionFrequencyEnabled',
      type: :dword,
      data: new_resource.enable_detection_frequency ? 1 : 0,
    },
    {
      name: 'DetectionFrequency',
      type: :dword,
      data: new_resource.custom_detection_frequency,
    },
    {
      name: 'NoAutoRebootWithLoggedOnUsers',
      type: :dword,
      data: new_resource.no_reboot_with_users_logged_on ? 1 : 0,
    },
    {
      name: 'NoAutoUpdate',
      type: :dword,
      data: new_resource.disable_automatic_updates ? 1 : 0,
    },
    {
      name: 'ScheduledInstallDay',
      type: :dword,
      data: new_resource.scheduled_install_day,
    },
    {
      name: 'ScheduledInstallTime',
      type: :dword,
      data: new_resource.scheduled_install_hour,
    },
    {
      name: 'AllowMUUpdateService',
      type: :dword,
      data: new_resource.update_other_ms_products ? 1 : 0,
    },
    {
      name: 'UseWUServer',
      type: :dword,
      data: new_resource.use_custom_update_server ? 1 : 0,
    }]
    action :create
  end
end
