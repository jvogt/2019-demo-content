# frozen_string_literal: true

if os.darwin?
  control 'Admin Control Enabled' do
    title 'Verifying that admin account control is enabled for System-Wide changes.'
    describe command("security authorizationdb read system.preferences > /tmp/system.preferences.plist; /usr/libexec/PlistBuddy -c 'Print :shared' /tmp/system.preferences.plist") do
      its('stdout') { should eq "false\n" }
      # its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end
end
