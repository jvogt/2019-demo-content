# frozen_string_literal: true

provides :windows_admin_control
description 'A resource to enforce Admin level access for system-wide changes'

unified_mode true

property :admin_account_control, [true, false], default: true, description: 'Require an admin user/pass to make system changes'

provides :admin_control, platform: 'windows'

action :set do
  if new_resource.admin_account_control
    registry_key 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' do
      recursive true
      values [{
        name: 'EnableLUA',
        type: :dword,
        data: 1,
      }]
      action :create_if_missing
    end
  end
end
