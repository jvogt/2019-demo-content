# frozen_string_literal: true

if os.darwin?
  # checking for Screensaver status and settings
  control 'Screensaver Check' do
    title 'Verifying that the screensaver is configured to come on and ask for a password'
    describe bash("UUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep \"IOPlatformUUID\" | sed -e 's/^.* \"\\(.*\\)\"$/\\1/'`; for i in $(find /Users -type d -maxdepth 1); do PREF=$i/Library/Preferences/ByHost/com.apple.screensaver.$UUID; if [ -e $PREF.plist ]; then /bin/echo -n \"Checking User: '$i': \"; defaults read $PREF.plist idleTime 2>&1; fi; done") do
      its('stdout') { should_not match(/\s0*(0|[1-9][0-9]{4,}|[2-9][0-9]{3}|1[3-9][0-9]{2}|12[1-9][0-9]|120[1-9])$/) }
    end
  end
end
