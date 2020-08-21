# frozen_string_literal: true

provides :mac_firewall
description 'A resource to enable the firewall'

unified_mode true

property :firewall, [true, false], default: true, description: 'Enable the macOS firewall'

provides :firewallclient, platform: 'mac_os_x'

load_current_value do
  firewall firewall_enabled?
end

def firewall_enabled?
  command = shell_out('/usr/bin/defaults', 'read', '/Library/Preferences/com.apple.alf', 'globalstate')
  command.stdout.chomp == '1'
end

action :set do
  converge_if_changed :firewall do
    execute 'update firewall status' do
      command "defaults write /Library/Preferences/com.apple.alf globalstate -int #{new_resource.firewall ? 1 : 0}"
      user 'root'
      action :run
    end
  end
end

action :reset do
  execute 'update firewall status' do
    command "defaults write /Library/Preferences/com.apple.alf globalstate -int #{new_resource.firewall ? 0 : 1}"
    user 'root'
    action :run
  end
end
