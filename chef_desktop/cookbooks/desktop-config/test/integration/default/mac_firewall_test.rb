# frozen_string_literal: true

if os.darwin?
  control 'Firewall Enabled' do
    title 'Checking that the Mac Firewall has been provisioned against all 3 profiles'
    describe bash('defaults read /Library/Preferences/com.apple.alf globalstate') do
      its('stdout') { should match '1' }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end
end
