# frozen_string_literal: true

if os.darwin?
  # Checking for Rescue account
  control 'Rescue Account Check' do
    title 'Confirming that a user account we specified was created'
    describe.one do
      describe user('MyAdmin') do
        it { should exist }
      end

      describe user('myadmin') do
        it { should exist }
      end
    end
  end

  control 'Group Check' do
    title 'Making sure the Staff and Admin groups exist'
    describe groups do
      its('names') { should include 'staff' }
      its('names') { should include 'admin' }
    end
  end

  control 'Group Membership Check' do
    title 'Verifying that our Rescue account is a member of the admins group'
    describe groups.where { name == 'admin' } do
      its('members') { should include 'MyAdmin' }
    end
    # make sure they are in the 'staff' group
  end
end
