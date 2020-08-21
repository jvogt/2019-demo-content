# frozen_string_literal: true

if os.windows?
  control 'Screensaver Enabled' do
    title 'Checking that the Screensaver has been enabled'
    describe registry_key('HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop') do
      its('ScreenSaveActive') { should eq '1' }
    end
  end

  control 'Screensaver Secure' do
    title 'Checking that the Screensaver has as a password set on it'
    describe registry_key('HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop') do
      its('ScreensaverIsSecure') { should eq '1' }
    end
  end

  control 'Screensaver Timeout' do
    title 'Checking that the Screensaver is set to come on after 20 minutes of inactivity'
    describe registry_key('HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop') do
      its(['ScreenSaveTimeOut']) { should eq '1200' }
    end
  end

  control 'Screensaver Name' do
    title 'Checking that the Screensaver has a proper scr file configured'
    describe registry_key('HKEY_CURRENT_USER\Control Panel\Desktop') do
      its(['scrnsave.exe']) { should eq 'mystify.scr' }
    end
  end
end
