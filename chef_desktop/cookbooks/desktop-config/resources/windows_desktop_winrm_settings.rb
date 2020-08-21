# frozen_string_literal: true

provides :windows_desktop_winrm_settings
description 'Use this to setup and teardown WinRM settings on a node. Chef Infra Client does not require this for operation'

unified_mode true

property :enabled, [true, false], desired_state: false, skip_docs: true, description: 'Internal property used by the resource to keep track of its state.'

provides :windows_desktop_winrm_settings, platform: 'windows'

load_current_value do
  enabled winrm_enabled?
end

def winrm_enabled?
  powershell_exec(<<-CODE).result
    $service_status = Get-Service -Name "WINRM"
    if ($service_status.Status -eq "Running"){
        return $true
    } else {return $false}
  CODE
end

action :enable do
  unless current_resource.enabled
    powershell_script 'set_winrm_enabled' do
      code <<-CODE
        # Set-WSManQuickConfig -Force -SkipNetworkProfileCheck;
        # 'netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" profile=public protocol=tcp localport=5985 remoteip=localsubnet new remoteip=any'
        Enable-PSRemoting -SkipNetworkProfileCheck -Force
        Set-NetFirewallRule -Name 'WINRM-HTTP-In-TCP-PUBLIC' -RemoteAddress Any
      CODE
    end
  end
end

action :disable do
  if current_resource.enabled
    powershell_script 'set_winrm_disabled' do
      code <<-CODE
        Disable-PSRemoting
      CODE
    end
  end
end
