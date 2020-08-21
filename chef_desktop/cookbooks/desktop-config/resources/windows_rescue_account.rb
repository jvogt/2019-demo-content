# frozen_string_literal: true

provides :windows_rescue_account
description 'A resource to provide Administrators with a rescue account'

unified_mode true

property :rescue_account_name, String, required: true, description: 'Name of the user to be created as a rescue account'
property :rescue_account_password, String, required: true, description: 'Corresponding password for that user'

provides :rescue_account, platform: 'windows'

action :create do
  user new_resource.rescue_account_name do
    password new_resource.rescue_account_password
  end

  group 'Administrators' do
    action :modify
    members new_resource.rescue_account_name
    append true
  end
end
