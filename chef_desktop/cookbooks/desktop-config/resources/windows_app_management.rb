# frozen_string_literal: true

provides :windows_app_management
description 'Configures nodes to use Gorilla to manage apps with'

unified_mode true

property :how_often_to_check_for_updates, String, description: 'How often should the Gorilla client check for updates. Options include minute, daily, weekly, monthly, none, once, on_logon, onstart, on_idle.'

provides :windows_app_management, platform: 'windows'

action :enable do
  directory 'gorilla' do
    inherits                   true
    mode                       '0777'
    path                       'c:\ProgramData\gorilla'
    recursive                  true
    action                     :create
  end

  directory 'cache' do
    inherits                   true
    mode                       '0777'
    path                       'c:\ProgramData\gorilla\cache'
    recursive                  true
    action                     :create
  end

  cookbook_file 'C:\ProgramData\gorilla\gorilla.exe' do
    source 'gorilla.exe'
    action :create_if_missing
  end

  cookbook_file 'C:\ProgramData\gorilla\config.yaml' do
    source 'config.yaml'
    action :create_if_missing
  end

  directory 'cache' do
    inherits                   true
    mode                       '0777'
    path                       'c:\ProgramData\gorilla'
    recursive                  true
    action                     :create
  end

  windows_task 'C:\ProgramData\gorilla\gorilla.exe' do
    command 'C:\ProgramData\gorilla\gorilla.exe'
    task_name 'gorilla'
    run_level :highest
    frequency new_resource.how_often_to_check_for_updates.to_sym
  end
end

action :disable do
  windows_task 'Disable the Gorilla App Client' do
    task_name 'gorilla'
    action :disable
  end
end
