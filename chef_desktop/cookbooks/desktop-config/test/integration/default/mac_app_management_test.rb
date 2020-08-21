# frozen_string_literal: true

if os.darwin?
  control 'Munki Directory' do
    title 'The munki directory was created succvessfully'
    describe directory('/usr/local/munki') do
      it { should exist }
    end
  end
  control 'Munki Download Directory' do
    title 'The munki directory was created succvessfully'
    describe directory('/usr/local/munki/munki_download') do
      it { should exist }
    end
  end
  control 'Munki Install Check' do
    title 'The Munki package should be installed'
    describe file('/usr/local/munki/munki_download/munki.pkg') do
      it { should exist }
    end
  end
  control 'Munki Plist Check' do
    title 'The Munki plist should exist'
    describe file('/Library/Preferences/ManagedInstalls.plist') do
      it { should exist }
    end
  end
  control 'Munki Plist Check URL' do
    title 'The URL should match what I speciifed'
    describe command("/usr/libexec/PlistBuddy -c 'Print :SoftwareRepoURL' /Library/Preferences/ManagedInstalls.plist") do
      its('stdout.strip') { should eq 'https://nwbakingstorage.blob.core.windows.net/munki' }
    end
  end
  # control 'Munki Plist Check Auth' do
  #   title 'The Plist should have the Additional HTTPHeaders Set'
  #   describe command("/usr/libexec/PlistBuddy -c 'Print :AdditionalHttpHeaders' /Library/Preferences/ManagedInstalls.plist") do
  #     its('stdout.strip') { should eq "Array {\n    Authorization: Basic bXVua2k6aWxvdmVtdW5raQ==\n}" }
  #   end
  # end
end
