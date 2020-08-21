include_controls 'acme_baseline_centos7' do
  skip_control 'xccdf_org.cisecurity.benchmarks_rule_2.1.1_Remove_telnet-server'
end

control "acme_app_1.0.1_apache_service_running" do
  title "Apache should be running"
  desc  "Acme App Servers require apache service to be running"
  impact 1.0
  describe service('httpd') do
    it{ should be_running }
  end
end
