# frozen_string_literal: true

if os.windows?
  control 'Admin User' do
    title 'Verifying that my testuser MyAdmin was properly created.'
    describe.one do
      describe user('MyAdmin') do
        it { should exist }
      end

      describe user('myadmin') do
        it { should exist }
      end
    end
  end

  control 'Admin Group' do
    title 'Checking that the Administrators Group exists'
    describe(groups.where { name == 'Administrators' }) do
      it { should exist }
      its('members') { should include 'MyAdmin' }
    end
  end
end
