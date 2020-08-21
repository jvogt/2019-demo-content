provides :windows_defender
description 'Use the **windows_defender** resource to enable or disable the Microsoft Windows Defender service.'

unified_mode true

action :enable do
  windows_service 'WinDefend' do
    action :start
    startup_type :automatic
  end
end

action :disable do
  windows_service 'WinDefend' do
    action :disable
  end
end