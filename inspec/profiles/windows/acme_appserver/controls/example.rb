include_controls 'acme_baseline' do
  # skip_control 'xccdf_org.cisecurity.benchmarks_rule_9.1.1_L1_Ensure_Windows_Firewall_Domain_Firewall_state_is_set_to_On_recommended'
end

control "acme_app_1.0.1_iis_feature" do
  title "IIS Should be Installed"
  desc  "Acme Windows App Servers require IIS Feature Installed"
  impact 1.0
  describe windows_feature('IIS-WebServer', :dism) do
    it{ should be_installed }
  end
end