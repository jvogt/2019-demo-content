# frozen_string_literal: true

if os.windows?
  control 'User Account Control' do
    title 'Checking that the Windows UA is enabled'
    describe registry_key('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System') do
      its('EnableLUA') { should eq 1 }
    end
  end
end
