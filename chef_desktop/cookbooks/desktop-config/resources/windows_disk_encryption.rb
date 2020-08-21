# frozen_string_literal: true

provides :windows_disk_encryption
description 'Enable or Disable BitLocker Drive Encryption with this resource.'

provides :disk_encryption, platform: 'windows'

unified_mode true

action :enable do
  powershell_script 'enable BitLocker' do
    code <<-CODE
    $drives = [System.IO.DriveInfo]::getdrives()
    $tpm = Get-TPM
    if($tpm.TpmPresent){
      foreach($drive in $drives){
          if ($drive.DriveType -eq "Fixed"){
              Write-Output "Now encrypting Drive: $Drive"
              $local_drive = $Drive.Name.ToString() -split('\\\\')
              manage-bde -on $local_drive
          }
      }
    }
    CODE
    not_if
    powershell_exec <<-CODE
      $service_status = Get-Service -Name "BDESVC"
      if ($service_status.Status -eq "Running"){
          return $true
      } else {return $false}
    CODE
  end
end

action :disable do
  powershell_script 'disable BitLocker' do
    code <<-CODE
    $drives = [System.IO.DriveInfo]::getdrives()
    foreach($drive in $drives){
        if ($drive.DriveType -eq "Fixed"){
            Write-Output "Now decrypting Drive: $Drive"
            $local_drive = $Drive.Name.ToString() -split('\\\\')
            manage-bde -off $local_drive
        }
    }
    CODE
    not_if
    powershell_exec <<-CODE
      $service_status = Get-Service -Name "BDESVC"
      if ($service_status.Status -eq "Running"){
          return $false
      } else {return $true}
    CODE
  end
end
