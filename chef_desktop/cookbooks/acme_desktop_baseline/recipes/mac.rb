# frozen_string_literal: true

desktop_screensaver 'Sets up a screensaver to come on and require a password after xx minutes' do
  idle_time 20 # value is in minutes
  require_password true
  delay_before_password_prompt 5 # value is in seconds
  action node['acme']['screensaver_enable'] ? :enable : :disable
end

rescue_account 'Configure an Admin level account for IT to use' do
  rescue_account_name 'MyAdmin'
  rescue_account_password '123Opscode!!'
  action :create
end

chef_schedule 'Setup the Chef client to run every 30 minutes' do
  running_interval 30
  start_time '16:10'
  action :enable
end

mac_password_policy 'Setup appropriate password complexity and rules' do
  max_failed_logins 5
  lockout_time 2
  maximum_password_age 365
  minimum_password_length 12
  minimum_numeric_characters 0
  minimum_lowercase_letters 0
  minimum_uppercase_letters 0
  minimum_special_characters 0
  remember_how_many_passwords 3
  exempt_user 'MyAdmin'
  action :set
end

mac_app_management 'Configure Munki on the node' do
  munki_client_download_url 'https://github.com/munki/munki/releases/download/v5.0.0/munkitools-5.0.0.4034.pkg'
  munki_repo_url 'https://nwbakingstorage.blob.core.windows.net/munki'
  # munki_user 'munki'
  # munki_password 'ILoveMunki'
  action :install
end

mac_power_management 'Set the Device to a defined power level' do
  computer_sleep_time 'never'
  display_sleep_time 'never'
  disk_sleep_time 'never'
  action :set
end

automatic_software_updates 'Settings for OS and Patch updates' do
  check true
  download true
  install_os true
  install_app_store true
  install_critical true
  action :set
end

disk_encryption 'Turning on FileVault for the console user' do
  action :enable
end

automatic_logout 'Automatically logout for inactivity' do
  autologout true
  autologout_time 900
end

admin_control 'Require Admin rights to perform system-wide changes' do
  admin_account_control true
  action :set
end

firewallclient 'Set Firewall Protection' do
  action :set
  firewall node['acme']['firewall_enable']
end
