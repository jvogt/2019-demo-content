# frozen_string_literal: true

if os.darwin?
  control 'Password History' do
    title 'OS Should only remember the past 3 passwords'
    describe command("sudo pwpolicy -u #{ENV['FVUSER']} -getaccountpolicies | grep '<string>Does not match any of last'") do
      its('stdout.strip') { should eq '<string>Does not match any of last 3 passwords</string>' }
    end
  end
  control 'Password Expiry' do
    title 'Passowrds should expire in 365 days'
    describe command("sudo pwpolicy -u #{ENV['FVUSER']} -getaccountpolicies | grep '<string>Change every 365 days</string>'") do
      its('stdout.strip') { should eq '<string>Change every 365 days</string>' }
    end
  end
  control 'Password Failed' do
    title 'Account should lockout after 5 failed attempts'
    describe command("sudo pwpolicy -u #{ENV['FVUSER']} -getaccountpolicies | grep '<integer>5</integer>'") do
      its('stdout.strip') { should eq '<integer>5</integer>' }
    end
  end
  control 'Password Lockout' do
    title 'Account should lockout for 2 minutes after max failed'
    describe command("sudo pwpolicy -u #{ENV['FVUSER']} -getaccountpolicies | grep '<integer>2</integer>'") do
      its('stdout.strip') { should eq '<integer>2</integer>' }
    end
  end
end
