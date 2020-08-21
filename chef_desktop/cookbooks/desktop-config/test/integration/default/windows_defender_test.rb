# frozen_string_literal: true

if os.windows?
  control 'Defender Enabled' do
    title 'Checking that the Windows Defender has been provisioned against all 3 profiles'
    describe service('WinDefend') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end
