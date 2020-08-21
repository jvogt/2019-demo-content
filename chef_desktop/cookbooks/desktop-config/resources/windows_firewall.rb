# frozen_string_literal: true

provides :windows_firewall
description 'A resource to enable the firewall'

unified_mode true

property :firewall, [true, false], default: true, description: 'Enable the Windows firewall'

provides :firewall, platform: 'windows'

load_current_value do
  firewall firewall_enabled?
end

def firewall_enabled?
  powershell_exec(<<-CODE).result
    $service_status = Get-Service -Name "mpssvc"
    if ($service_status.Status -eq "Running"){
        return $true
    } else {return $false}
  CODE
end

action :set do
  converge_if_changed :firewall do
    powershell_script 'Turn on the firewall' do
      code <<-CODE
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled #{new_resource.firewall ? 1 : 0}
      CODE
    end
  end
end

action :reset do
  powershell_script 'Turn on the firewall' do
    code <<-CODE
      Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled #{new_resource.firewall ? 1 : 0}
    CODE
  end
end