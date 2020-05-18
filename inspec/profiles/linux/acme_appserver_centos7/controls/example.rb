include_controls 'acme_baseline_centos7' do
  skip_control 'xccdf_org.cisecurity.benchmarks_rule_2.1.1_Remove_telnet-server'
end

control "acme_app_1.0.1_apache_service_enabled" do
  title "Apache should be enabled"
  desc  "Acme App Servers require apache service to be enabled"
  impact 1.0
  describe service('apache2') do
    it{ should be_enabled }
  end
end
