# frozen_string_literal: true

if os.windows?
  control 'Automatic Logout Enabled' do
    title 'Checking that the autologout has been enabled'
    describe registry_key('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System') do
      its('InactivityTimeoutSecs') { should eq 900 }
    end
  end
end
