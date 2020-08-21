# frozen_string_literal: true

if os.windows?
  control 'Gorilla Directory' do
    title 'Checking that the Gorilla directory was created properly at \Programdata\Gorilla'
    describe file('c:\ProgramData\gorilla') do
      its('type') { should eq :directory }
    end
  end

  control 'Gorilla Cache Directory' do
    title 'Checking that the Gorilla Cache directory was created properly at \Programdata\Gorilla\Cache'
    describe file('c:\\ProgramData\\gorilla\\cache') do
      its('type') { should eq :directory }
    end
  end

  control 'Gorilla File' do
    title 'Checking that the Gorilla exe was created properly at \Programdata\Gorilla\Gorilla.exe'
    describe file('C:\\ProgramData\\gorilla\\gorilla.exe') do
      its('type') { should cmp 'file' }
      it { should be_file }
      it { should_not be_directory }
    end
  end

  control 'Gorilla Config File' do
    title 'Checking that the Gorilla Configuration was created properly at \Programdata\Gorilla\config.yaml'
    describe file('C:\\ProgramData\\gorilla\\config.yaml') do
      its('type') { should cmp 'file' }
      it { should be_file }
      it { should_not be_directory }
      it { should be_readable.by_user('NT AUTHORITY\\SYSTEM') }
    end
  end

  control 'Gorilla Windows Task' do
    title 'Checking the Gorilla Client Scheduled Task'
    desc 'Verifying that the scheduled task is correctly calling gorilla'
    describe windows_task('gorilla') do
      its('task_to_run') { should cmp 'C:\\ProgramData\\gorilla\\gorilla.exe' }
      its('run_as_user') { should eq 'NT AUTHORITY\\SYSTEM' }
      it { should be_enabled }
    end
  end
end
