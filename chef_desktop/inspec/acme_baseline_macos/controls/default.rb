require_controls 'cis-applemacos10.15-level1' do
  control 'xccdf_org.cisecurity.benchmarks_rule_5.19_System_Integrity_Protection_status'
  control 'xccdf_org.cisecurity.benchmarks_rule_5.7_Do_not_enable_the_root_account'
  control 'xccdf_org.cisecurity.benchmarks_rule_2.8.2_Time_Machine_Volumes_Are_Encrypted'
  control 'xccdf_org.cisecurity.benchmarks_rule_2.5.3_Enable_Firewall'
  control 'xccdf_org.cisecurity.benchmarks_rule_1.3_Enable_Download_new_updates_when_available'
  control 'xccdf_org.cisecurity.benchmarks_rule_5.2.2_Set_a_minimum_password_length'
end

# control "acme_chef_service_installed" do
#   title "osquery should be running"
#   desc  "baseline requires chef"
#   impact 1.0
#   describe scheduled_task('chef-infra') do
#     it{ should exist }
#     it{ should be_enabled }
#   end
# end
