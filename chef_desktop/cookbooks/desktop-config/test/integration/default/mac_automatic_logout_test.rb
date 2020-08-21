# frozen_string_literal: true

if os.darwin?
  control 'Autologout Enabled' do
    title 'Checking that Autologout is set to 900 seconds'
    describe bash('defaults read /Library/Preferences/.GlobalPreferences.plist com.apple.autologout.AutoLogOutDelay') do
      its('stdout') { should cmp 900 }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end
end