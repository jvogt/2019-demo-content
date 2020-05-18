require_controls 'cis-windows2016rtm-release1607-level1-memberserver' do
  control 'xccdf_org.cisecurity.benchmarks_rule_18.9.58.2.2_L1_Ensure_Do_not_allow_passwords_to_be_saved_is_set_to_Enabled'
  control 'xccdf_org.cisecurity.benchmarks_rule_9.1.1_L1_Ensure_Windows_Firewall_Domain_Firewall_state_is_set_to_On_recommended'
end

control "acme_1.1.2_max_password_age" do
  title "Maximum password age must be 60 or fewer days"
  desc  "Acme Requires password age <= 60 days"
  impact 1.0
  describe security_policy do
    its("MaximumPasswordAge") { should be <= 60 }
  end
  describe security_policy do
    its("MaximumPasswordAge") { should be > 0 }
  end
end

# baseline = [
#   'kb023211',
#   'kb234223',
#   ...
# ]

# baseline.each do | p |
#   package p do
#     it { should be_installed }
#   end
# end