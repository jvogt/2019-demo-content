# frozen_string_literal: true

if os.darwin?
  control 'Auto Software Update' do
    title 'making sure that the system auto-patches'
    describe command("/usr/libexec/PlistBuddy -c 'Print :AutomaticCheckEnabled' /Library/Preferences/com.apple.SoftwareUpdate.plist") do
      its('stdout') { should eq "true\n" }
    end
    describe command("/usr/libexec/PlistBuddy -c 'Print :AutomaticDownload' /Library/Preferences/com.apple.SoftwareUpdate.plist") do
      its('stdout') { should eq "true\n" }
    end
    describe command("/usr/libexec/PlistBuddy -c 'Print :CriticalUpdateInstall' /Library/Preferences/com.apple.SoftwareUpdate.plist") do
      its('stdout') { should eq "true\n" }
    end
    describe command("/usr/libexec/PlistBuddy -c 'Print :AutomaticallyInstallMacOSUpdates' /Library/Preferences/com.apple.SoftwareUpdate.plist") do
      its('stdout') { should eq "true\n" }
    end
    describe command("/usr/libexec/PlistBuddy -c 'Print :AutoUpdate' /Library/Preferences/com.apple.commerce.plist") do
      its('stdout') { should eq "true\n" }
    end
  end
end
