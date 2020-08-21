# frozen_string_literal: true

if os.darwin?
  # checking FileVault status
  control 'FileVault Check' do
    title 'Making sure that FileVault is correctly enabled'
    describe.one do
      describe bash('fdesetup status') do
        its('stdout') { should match(/FileVault is Off.\nDeferred enablement appears to be active for user '#{ENV['FVUSER']}'.\n/) }
      end

      describe bash('fdesetup status') do
        its('stdout') { should match(/FileVault\s+is\s+On/) }
      end
    end
  end
end
