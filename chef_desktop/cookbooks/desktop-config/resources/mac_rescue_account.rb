# frozen_string_literal: true

provides :mac_rescue_account
description 'A Resource for adding an admin account to the node. The password must conform to the password policy'

unified_mode true

property :rescue_account_name, String, required: true, description: 'the name of the user account you wish to add'
property :rescue_account_password, String, required: true, description: 'the corresponding password for that user'

provides :rescue_account, platform: 'mac_os_x'

action :create do
  user new_resource.rescue_account_name do
    password new_resource.rescue_account_password
  end

  group 'admin' do
    action :modify
    members new_resource.rescue_account_name
    append true
  end
end

action :delete do
  user new_resource.rescue_account_name do
    action :remove
  end
end

action :enable do
  user new_resource.rescue_account_name do
    action :unlock
  end
end

action :disable do
  user new_resource.rescue_account_name do
    action :lock
  end
end
