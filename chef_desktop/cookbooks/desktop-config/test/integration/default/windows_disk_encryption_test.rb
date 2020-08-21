# frozen_string_literal: true

if os.windows?
  myhdstatus = <<-RUNTHISNOW
    $tpm = Get-TPM
    if($tpm.TpmPresent){
      $svcstatus = Get-Service -Name "BDESVC"
      if ($svcstatus.Status -eq "Running"){
          return $true
      } else {return $false}
    }
    else{
      return $true
    }
  RUNTHISNOW
  control 'HD Encryption' do
    title 'Checking that BitLocker Drive Encryption is correctly configured'
    describe powershell(myhdstatus) do
      its('strip') { should eq 'True' }
    end
  end
end
