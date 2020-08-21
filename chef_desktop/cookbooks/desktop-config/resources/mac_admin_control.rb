# frozen_string_literal: true

provides :mac_admin_control

description 'A resource to enforce Admin level access for system-wide changes'

unified_mode true

property :admin_account_control, [true, false], default: true, description: 'Require an admin user/pass to make system changes'

provides :admin_control, platform: 'mac_os_x'

action :set do
  pwpolicy_script = ::File.join(Chef::Config[:file_cache_path], 'system.preferences.plist')
  code_string = <<~CODE
    security authorizationdb read system.preferences > #{pwpolicy_script}
    /usr/libexec/PlistBuddy -c "Set :shared %s" #{pwpolicy_script}
    security authorizationdb write system.preferences < #{pwpolicy_script}
  CODE

  if new_resource.admin_account_control
    bash 'Enable Admin requirement for System-Wide Changes' do
      code code_string % false
      not_if { ::File.exist?(pwpolicy_script) }
    end
  else
    bash 'Disable Admin requirement for System-Wide Changes' do
      code code_string % true
    end
  end
end
