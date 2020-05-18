# xccdf_org.cisecurity.benchmarks_rule_18.9.58.3.9.1_L1_Ensure_Always_prompt_for_password_upon_connection_is_set_to_Enabled
# xccdf_org.cisecurity.benchmarks_rule_18.8.35.1_L1_Ensure_Configure_Offer_Remote_Assistance_is_set_to_Disabled
# xccdf_org.cisecurity.benchmarks_rule_18.8.35.2_L1_Ensure_Configure_Solicited_Remote_Assistance_is_set_to_Disabled
# xccdf_org.cisecurity.benchmarks_rule_18.9.58.2.2_L1_Ensure_Do_not_allow_passwords_to_be_saved_is_set_to_Enabled
# xccdf_org.cisecurity.benchmarks_rule_18.9.58.3.9.2_L1_Ensure_Require_secure_RPC_communication_is_set_to_Enabled
# xccdf_org.cisecurity.benchmarks_rule_18.9.58.3.9.3_L1_Ensure_Set_client_connection_encryption_level_is_set_to_Enabled_High_Level
# xccdf_org.cisecurity.benchmarks_rule_18.9.58.3.11.1_L1_Ensure_Do_not_delete_temp_folders_upon_exit_is_set_to_Disabled
# xccdf_org.cisecurity.benchmarks_rule_18.9.58.3.11.2_L1_Ensure_Do_not_use_temporary_folders_per_session_is_set_to_Disabled
# xccdf_org.cisecurity.benchmarks_rule_18.9.58.3.3.2_L1_Ensure_Do_not_allow_drive_redirection_is_set_to_Enabled
registry_key 'HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows NT\\Terminal Services' do
  values [
    { name: 'fPromptForPassword', type: :dword, data: 1 },
    { name: 'fAllowUnsolicited', type: :dword, data: 0 },
    { name: 'fAllowToGetHelp', type: :dword, data: 0 },
    { name: 'DisablePasswordSaving', type: :dword, data: 1 },
    { name: 'fEncryptRPCTraffic', type: :dword, data: 1 },
    { name: 'MinEncryptionLevel', type: :dword, data: 3 },
    { name: 'DeleteTempDirsOnExit', type: :dword, data: 1 },
    { name: 'PerSessionTempDir', type: :dword, data: 1 },
    { name: 'fDisableCdm', type: :dword, data: 1 },
  ]
  recursive true
  action :create
end