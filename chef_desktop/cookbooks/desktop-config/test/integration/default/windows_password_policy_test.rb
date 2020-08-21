# frozen_string_literal: true

if os.windows?
  control 'Password Length' do
    title 'Confirming that password length is at least 12 characters'
    describe security_policy do
      its('MinimumPasswordLength') { should be >= 12 }
    end
  end

  control 'Password Complexity' do
    title 'Verifing that password complexity is enabled'
    describe security_policy do
      its('PasswordComplexity') { should eq 1 }
    end
  end
end
