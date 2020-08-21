# Load ChefSpec and put our test into ChefSpec mode.
require 'chefspec'

# Describing our custom resource.
describe 'windows_rescue_account' do
  # Normally ChefSpec skips running resources, but for this test we want to
  # actually run this one custom resource.
  step_into :windows_rescue_account

  platform 'windows'

  # Create an example group for testing the resource defaults.
  context 'setting the rescue account' do
    # Set the subject of this example group to a snippet of recipe code calling
    # our custom resource.
    recipe do
      rescue_account_name 'MyAdmin'
      rescue_account_password '123Opscode!!'
      action :create
    end
    # Confirm that the resources created by our custom resource's action are
    # correct. ChefSpec matchers all take the form `action_type(name)`.
    xit { expect(chef_run).to create_user('MyAdmin') }
  end
end