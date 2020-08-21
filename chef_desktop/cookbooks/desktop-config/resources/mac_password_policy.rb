# frozen_string_literal: true

provides :mac_password_policy
description 'Used to setup password complexity, password length, etc'

unified_mode true

property :max_failed_logins, Integer, description: 'The maximum number of failed logins before you are locked out'
property :lockout_time, Integer, description: 'The amount of time your account is locked out after you exceed max failed logins'
property :maximum_password_age, Integer, default: 365, description: 'The maximum age in days for a password before it must be changed, defaults to 365'
property :minimum_password_length, Integer, default: 12, description: 'The minimum length a password must be'
property :minimum_numeric_characters, Integer, default: 0, description: 'The minimum number of numbers that must be in a password'
property :minimum_lowercase_letters, Integer, default: 0, description: 'The minimum number of lower case letters that must be in a password'
property :minimum_uppercase_letters, Integer, default: 0, description: 'The minimum number of upper case letters that must be in a password'
property :minimum_special_characters, Integer, default: 0, description: 'The minimum number of special characters that must be in a password. Eg. *&^%'
property :remember_how_many_passwords, Integer, default: 3, description: 'The number of previous passwords to remember to prevent users for keeping stale passwords'
property :exempt_user, String, description: 'A user to whom the password policy is not applied'

provides :mac_password_policy, platform: 'mac_os_x'

action :set do
  pwpolicy_script = Chef::Config[:file_cache_path] + '/pwpolicy.sh'
  template pwpolicy_script do
    cookbook 'desktop-config'
    source 'pwpolicy.sh.erb'
    owner 'root'
    group 'wheel'
    mode '0755'
    variables(
      max_failed_logins: new_resource.max_failed_logins,
      lockout: new_resource.lockout_time,
      expires: new_resource.maximum_password_age,
      minimum_password_length: new_resource.minimum_password_length,
      numeric: new_resource.minimum_numeric_characters,
      lower: new_resource.minimum_lowercase_letters,
      upper: new_resource.minimum_uppercase_letters,
      special: new_resource.minimum_special_characters,
      history: new_resource.remember_how_many_passwords,
      exempt_user: new_resource.exempt_user
    )
  end

  execute 'update password policy' do
    command pwpolicy_script
    user 'root'
    action :run
  end
end
