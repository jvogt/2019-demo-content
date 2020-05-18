if node['cis']['xccdf_org.cisecurity.benchmarks_rule_9.1.1_L1_Ensure_Windows_Firewall_Domain_Firewall_state_is_set_to_On_recommended']
  fw_enabled = 1
else
  fw_enabled = 0
end

registry_key 'HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\WindowsFirewall\\DomainProfile' do
  values [
    { name: 'EnableFirewall', type: :dword, data: fw_enabled },
  ]
  recursive true
  action :create
end