# frozen_string_literal: true

provides :mac_desktop_screensaver
description 'A resource for configuring a secure Screensaver'

unified_mode true

property :idle_time, Integer, default: 20, description: 'Time in minutes before the the Screensaver comes on'
property :delay_before_password_prompt, Integer, default: 5, description: 'Time in seconds to interrupt the Screensaver before it asks for your password'
property :require_password, [true, false], default: true, description: 'True/false to enable a password for your Screensaver. Default is True'
property :label, String, default: 'chefsoftware', description: 'A label used to identify your Screensaver in the list of running resources. Default is chefsoftware'

provides :desktop_screensaver, platform: 'mac_os_x'

action :enable do
  prefix = 'com.' + new_resource.label

  screensaver_profile = {
    'PayloadIdentifier' => "#{prefix}.screensaver",
    'PayloadRemovalDisallowed' => true,
    'PayloadScope' => 'System',
    'PayloadType' => 'Configuration',
    'PayloadUUID' => 'CEA1E58D-9D0F-453A-AA52-830986A8366C',
    'PayloadOrganization' => new_resource.label,
    'PayloadVersion' => 1,
    'PayloadDisplayName' => 'Screensaver',
    'PayloadContent' => [
      {
        'PayloadType' => 'com.apple.ManagedClient.preferences',
        'PayloadVersion' => 1,
        'PayloadIdentifier' => "#{prefix}.screensaver",
        'PayloadUUID' => '3B2AD6A9-F99E-4813-980A-4147617B2E75',
        'PayloadEnabled' => true,
        'PayloadDisplayName' => 'ScreenSaver',
        'PayloadContent' => {
          'com.apple.screensaver' => {
            'Forced' => [
              {
                'mcx_preference_settings' => {
                  'idleTime' =>
                    new_resource.idle_time * 60,
                  'askForPassword' =>
                    new_resource.require_password,
                  'askForPasswordDelay' =>
                    new_resource.delay_before_password_prompt,
                },
              },
            ],
          },
        },
      },
    ],
  }

  osx_profile 'Install screensaver profile' do
    profile screensaver_profile
  end
end

action :disable do
  prefix = 'com.' + new_resource.label
  
  osx_profile "#{prefix}.screensaver" do
    action :remove
  end
end
