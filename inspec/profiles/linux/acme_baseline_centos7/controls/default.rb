# encoding: utf-8
# copyright: 2018, The Authors

require_controls 'cis-centos7-level1' do
  control 'xccdf_org.cisecurity.benchmarks_rule_9.2.20_Check_for_Presence_of_User_.forward_Files'
  control 'xccdf_org.cisecurity.benchmarks_rule_9.2.13_Check_User_Home_Directory_Ownership'
  control 'xccdf_org.cisecurity.benchmarks_rule_9.2.9_Check_Permissions_on_User_.netrc_Files'
  control 'xccdf_org.cisecurity.benchmarks_rule_4.2.2_Disable_ICMP_Redirect_Acceptance'
  control 'xccdf_org.cisecurity.benchmarks_rule_2.1.1_Remove_telnet-server'
end

describe service('ntpd') do
  it { should be_started }
end