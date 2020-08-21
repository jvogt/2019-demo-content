# frozen_string_literal: true

provides :windows_password_policy
description 'Used to setup password complexity, password length, etc'

unified_mode true

property :require_complex_passwords, [true, false], default: true, description: 'A True/False option to require special characters, upper, lower, etc in the password'
property :minimum_password_length, Integer, default: 12, description: 'Sets the minimum password length, defaults to 12 Characters'
property :maximum_password_age, Integer, default: 365, description: 'The maximum age in days for a password before it must be changed, defaults to 365'
property :password_never_expires, [true, false], description: 'True/False to never expire the passwords, set to True by default'
property :group_name_for_password_never_expires, String, default: 'Administrators', description: 'The group to which the password_never_expires rule applies. Defaults to Admins'
property :change_password_at_next_logon, [true, false], default: false, description: 'Force all users in a local user group to change passwords at next logon'
property :group_name_for_expired_passwords, String, default: 'Users', description: 'The group whose passwords were just to change at the next login'

provides :windows_password_policy, platform: 'windows'

action :set do
  # Password change at next logon requires ensuring that Password Never Expires is cleared first.

  if new_resource.require_complex_passwords == true
    powershell_script 'set local password complexity policy' do
      code <<-CODE
      $Secedit_CFGFile_Path = [System.IO.Path]::GetTempFileName();
      $Secedit_Path = "$env:SystemRoot\\system32\\secedit.exe";
      $Secedit_Arguments_Export = "/export /cfg $Secedit_CFGFile_Path /quiet";
      $Secedit_Arguments_Import = "/configure /db c:\\windows\\security\\local.sdb /cfg $Secedit_CFGFile_Path /areas SECURITYPOLICY";
      Start-Process -FilePath $Secedit_Path -ArgumentList $Secedit_Arguments_Export -Wait;
      (Get-Content $Secedit_CFGFile_Path) -Replace "PasswordComplexity = 0","PasswordComplexity = 1" | Out-File $Secedit_CFGFile_Path;
      Start-Process -FilePath $Secedit_Path -ArgumentList $Secedit_Arguments_Import -Wait;
      Remove-Item $Secedit_CFGFile_Path -Force;
      CODE
      not_if <<-CODE
      $Secedit_CFGFile_Path = [System.IO.Path]::GetTempFileName();
      $Secedit_Path = "$env:SystemRoot\\system32\\secedit.exe";
      $Secedit_Arguments_Export = "/export /cfg $Secedit_CFGFile_Path /quiet";
      Start-Process -FilePath $Secedit_Path -ArgumentList $Secedit_Arguments_Export -Wait;
      $blob = ((Get-Content $Secedit_CFGFile_Path) | Select-String -Pattern 'PasswordComplexity =').ToString();
      $is_complexity_enabled = (($blob.Split("="))[-1]).trim()
      if ($is_complexity_enabled -eq '1'){
        return $true
      }
      else {return $false}
      CODE
    end
  end

  powershell_script 'set_local_password_length_policy' do
    code <<-CODE
      net accounts /minpwlen:#{new_resource.minimum_password_length}
    CODE
  end

  if defined?(new_resource.maximum_password_age)
    powershell_script 'set the maximum password age' do
      code <<-CODE
      $Secedit_CFGFile_Path = [System.IO.Path]::GetTempFileName();
      $Secedit_Path = "$env:SystemRoot\\system32\\secedit.exe";
      $Secedit_Arguments_Export = "/export /cfg $Secedit_CFGFile_Path /quiet";
      $Secedit_Arguments_Import = "/configure /db c:\\windows\\security\\local.sdb /cfg $Secedit_CFGFile_Path /areas SECURITYPOLICY";
      Start-Process -FilePath $Secedit_Path -ArgumentList $Secedit_Arguments_Export -Wait;
      $blob = ((Get-Content $Secedit_CFGFile_Path) | Select-String -Pattern 'MaximumPasswordAge =').ToString();
      $old_max_password_age = (($blob.Split("="))[-1]).trim()
      (Get-Content $Secedit_CFGFile_Path) -Replace "MaximumPasswordAge = $old_max_password_age","MaximumPasswordAge = #{new_resource.maximum_password_age}" | Out-File $Secedit_CFGFile_Path;
      Start-Process -FilePath $Secedit_Path -ArgumentList $Secedit_Arguments_Import -Wait;
      Remove-Item $Secedit_CFGFile_Path -Force;
      CODE
    end
  end

  if new_resource.password_never_expires == true
    local_admins = powershell_exec <<-CODE
      $active_users = Get-CimInstance Win32_UserAccount -filter "Disabled = 'false'"
      [string[]]$admins = ''
      foreach($user in $active_users){
          if((Get-LocalGroupMember -group "#{new_resource.group_name_for_password_never_expires}").Name -notcontains $user.Caption) {
            $admins += $user.Name
          }
      }
    CODE

    local_admins.each do |local_admin|
      powershell_script 'set the maximum password age' do
        code <<-CODE
        Set-LocalUser -Name #{local_admin} -PasswordNeverExpires 1
        CODE
      end
    end
  elsif new_resource.password_never_expires == false
    local_admins = powershell_exec <<-CODE
      $active_users = Get-CimInstance Win32_UserAccount -filter "Disabled = 'false'"
      [string[]]$admins = ''
      foreach($user in $active_users){
          if((Get-LocalGroupMember -group "#{new_resource.group_name_for_password_never_expires}").Name -notcontains $user.Caption) {
            $admins += $user.Name
          }
      }
    CODE

    local_admins.each do |local_admin|
      powershell_script 'set the maximum password age' do
        code <<-CODE
        Set-LocalUser -Name #{local_admin} -PasswordNeverExpires 0
        CODE
      end
    end
  end

  if new_resource.change_password_at_next_logon == true
    local_users = powershell_exec <<-CODE
      $active_users = Get-CimInstance Win32_UserAccount -filter "Disabled = 'false'"
      [string[]]$non_admins = ''
      foreach($user in $active_users){
          if((Get-LocalGroupMember -group "Administrators").Name -notcontains $user.Caption) {
            $non_admins += $user.Name
          }
      }
    CODE

    local_users.each do |local_user|
      pwd_state = powershell_exec <<-CODE
        $user = Get-LocalUser -Name #{local_user}
        [boolean]($user.PasswordExpires -as [DateTime])
      CODE

      if pwd_state == false
        raise ArgumentError, "User #{local_user} has no expiration date on their password"
      end

      powershell_script 'expire local passwords' do
        code <<-CODE
          $userPath = "WinNT://"  + [System.Environment]::MachineName + "/" + "#{local_user}";
          $de = New-Object System.DirectoryServices.DirectoryEntry($userPath)
          $de.Properties["PasswordExpired"].Value = 1;
        CODE
      end
    end
  end
end
