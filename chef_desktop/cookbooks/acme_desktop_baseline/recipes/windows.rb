# frozen_string_literal: true

desktop_screensaver 'Sets up a Screensaver to come on and require a password after xx minutes' do
  require_password true
  idle_time 20
  allow_lower_user_idle_time false
  screensaver_name 'mystify.scr'
  action :enable
end

disk_encryption 'Turns on BitLocker Drive Encryption' do
  action :enable
end

windows_password_policy 'Settings for password complexity, length and duration' do
  require_complex_passwords true
  minimum_password_length 12
  maximum_password_age 365
  action :set
end

rescue_account 'Configure an Admin level account for IT to use' do
  rescue_account_name 'MyAdmin'
  rescue_account_password '123Opscode!!'
  action :create
end

windows_update_settings 'Settings to Configure Windows Nodes to automatically receive updates' do
  disable_os_upgrades false
  elevate_non_admins true
  add_to_target_wsus_group false
  block_windows_update_website false
  automatic_update_option 4
  automatically_install_minor_updates false
  enable_detection_frequency false
  custom_detection_frequency 22
  no_reboot_with_users_logged_on true
  disable_automatic_updates false
  scheduled_install_day 6
  scheduled_install_hour 20
  update_other_ms_products false
  use_custom_update_server false
  action :enable
end

windows_desktop_winrm_settings 'Settings to Set WinRM on a node for desktop-config' do
  action :nothing
end

windows_app_management 'Use Gorilla to manage Apps' do
  how_often_to_check_for_updates 'daily'
  action :enable
end

chef_client_scheduled_task 'Run Chef Infra Client every 30 minutes' do
  frequency 'minute'
  frequency_modifier 30
end

windows_power_management 'Set the Device to a defined power level' do
  power_scheme_label 'Unrestricted'
  power_level 'ultimate'
  action :set
end

automatic_logout 'Automatically logout for inactivity' do
  autologout true
  autologout_time 900
end

admin_control 'Require Admin rights to perform system-wide changes' do
  admin_account_control true
  action :set
end

windows_defender 'Ensure the AV is on' do
  action :enable
end

firewall 'enable the node firewall' do
  action :set
end

# security_policy 'Local Policy' do
#   policy_template 'C:\Windows\security\templates\chefNewPolicy.inf'
#   database 'C:\Windows\security\database\chef.sdb'
#   action :configure
# end

# package 'XBOX Live' do
#   action :remove
# end