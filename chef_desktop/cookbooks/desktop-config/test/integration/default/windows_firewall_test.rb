# frozen_string_literal: true

if os.windows?
  control 'Firewall Enabled' do
    title 'Checking that the Windows Firewall has been provisioned against all 3 profiles'
    describe service('mpssvc') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end
