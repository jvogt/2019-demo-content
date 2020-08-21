# frozen_string_literal: true

if os.windows?
  mywinrmstatus = <<-RUNTHISNOW
    $winrmstatus = Test-WSMan
    if ($winrmstatus.ChildNodes){
        return $true
    } else {return $false}
  RUNTHISNOW
  control 'WINRM Status' do
    title 'Checking that WinRM is correctly configured'
    describe powershell(mywinrmstatus) do
      its('strip') { should eq 'True' }
    end
  end
end
