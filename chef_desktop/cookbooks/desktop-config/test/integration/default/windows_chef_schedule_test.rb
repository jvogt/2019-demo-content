# frozen_string_literal: true

if os.windows?
  control 'Chef-Client Windows Task' do
    title 'Checking that the Chef-Client scheduled task was properly created'
    describe windows_task('chef-client') do
      its('task_to_run') { should cmp "C:\\windows\\system32\\cmd.exe /c 'C:/opscode/chef/bin/chef-client -L C:\\chef/log/client.log -c C:\\chef/client.rb'" }
      # its('state') { should eq 'Ready' } - Inspec bug, it incorrectly believes this is an undefined method
      its('run_as_user') { should eq 'NT AUTHORITY\\SYSTEM' }
      it { should be_enabled }
    end
  end
end
