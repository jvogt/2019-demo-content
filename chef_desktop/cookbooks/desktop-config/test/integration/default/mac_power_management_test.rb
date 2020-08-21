# frozen_string_literal: true

if os.darwin?
  control 'Mac Computer Power' do
    title 'Making sure that computer power settings are correct for Kiosk-like experience.'
    describe bash('sudo systemsetup -getcomputersleep') do
      its('stdout') { should match 'Computer Sleep: Never' }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end

  control 'Mac Display Power' do
    title 'Making sure that display power settings are correct for Kiosk-like experience.'
    describe bash('sudo systemsetup -getdisplaysleep') do
      its('stdout') { should match 'Display Sleep: Never' }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end

  control 'Mac HD Power' do
    title 'Making sure that HD power settings are correct for Kiosk-like experience.'
    describe bash('sudo systemsetup -getharddisksleep') do
      its('stdout') { should match 'Hard Disk Sleep: Never' }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end
end
