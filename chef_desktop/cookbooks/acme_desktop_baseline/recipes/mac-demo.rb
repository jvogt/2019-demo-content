# frozen_string_literal: true

desktop_screensaver 'Sets up a screensaver to come on and require a password after xx minutes' do
  idle_time 20 # value is in minutes
  require_password true
  delay_before_password_prompt 5 # value is in seconds
  action node['acme']['screensaver_enable'] ? :enable : :disable
end

firewallclient 'Set Firewall Protection' do
  action :set
  firewall node['acme']['firewall_enable']
end

file '/Users/jvogt/firewall' do
  action node['acme']['firewall_enable'] ? :create : :delete
end
