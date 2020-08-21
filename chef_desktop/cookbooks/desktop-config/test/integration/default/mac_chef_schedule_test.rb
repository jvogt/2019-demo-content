# frozen_string_literal: true

if os.darwin?
  control 'Chef Client Check' do
    title 'Ensuring that the Chef-Client is correctly setup as a service'
    describe service('com.chef.chef-client') do
      it { should be_installed }
      it { should be_enabled }
    end
  end
end
