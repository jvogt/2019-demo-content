# frozen_string_literal: true

if os.windows?
  control 'Use WindowsUpdate' do
    title 'Ensure the machine is getting updates from Microsoft and not a WSUS server'
    describe.one do
      describe registry_key('UseWUServer', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('UseWUServer') { should eq 0 }
      end

      describe registry_key('UseWUServer', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('UseWUServer') { should eq nil }
      end
    end
  end

  control 'Auto Download Updates' do
    title 'Make sure the node is set to download and schedule updates for the user'
    describe registry_key('AUOptions', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
      its('AUOptions') { should eq 4 }
    end
  end

  control 'Automatic Updates' do
    title 'We want the updates to be Automatic'
    describe registry_key('NoAutoUpdate', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
      its('NoAutoUpdate') { should eq 0 }
    end
  end

  control 'Scheduled Install Day' do
    title 'If the user does not install the updates, we will do it on Saturday'
    describe.one do
      describe registry_key('ScheduledInstallDay', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('ScheduledInstallDay') { should eq 6 }
      end

      describe registry_key('ScheduledInstallDay', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('ScheduledInstallDay') { should eq nil }
      end
    end
  end

  control 'Scheduled Install Time' do
    title 'If the user does not install the updates, we will do it on Saturday at 8pm'
    desc 'the time is converted from DEC to HEX'
    describe.one do
      describe registry_key('ScheduledInstallTime', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('ScheduledInstallTime') { should eq 20 }
      end

      describe registry_key('ScheduledInstallTime', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('ScheduledInstallTime') { should eq nil }
      end
    end
  end

  control 'Reschedule Install Time' do
    title 'If the Updates do not happy on Saturday, wait 15 minutes after they next logon to start applying them'
    describe.one do
      describe registry_key('RescheduleWaitTime', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('RescheduleWaitTime') { should eq 15 }
      end

      describe registry_key('RescheduleWaitTime', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('RescheduleWaitTime') { should eq nil }
      end
    end
  end

  control 'Reboot Control' do
    title 'Please do not reboot the laptop after installing patches if someone is logged on currently.'
    describe.one do
      describe registry_key('NoAutoRebootWithLoggedOnUsers', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('NoAutoRebootWithLoggedOnUsers') { should eq 1 }
      end

      describe registry_key('NoAutoRebootWithLoggedOnUsers', 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU') do
        its('NoAutoRebootWithLoggedOnUsers') { should eq nil }
      end
    end
  end
end
