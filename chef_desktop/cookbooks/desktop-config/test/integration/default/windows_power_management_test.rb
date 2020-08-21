# frozen_string_literal: true

if os.windows?
  control 'Power Scheme' do
    title 'The running Power Scheme should be '
    script = <<-EOH
      $powerplan = powercfg /GETACTIVESCHEME
      $top = $powerplan.Split('(')[1]
      $top.Split(')')[0]
    EOH

    describe powershell(script) do
      its('stdout.strip') { should eq 'Unrestricted Ultimate Power' }
    end
  end

end
