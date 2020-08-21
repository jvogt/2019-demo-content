# frozen_string_literal: true

provides :mac_app_management
description 'A Mac resource for configuring nodes to use Munki to manage apps'

unified_mode true

property :munki_repo_url, String, description: 'The URL of the repository nodes will use to download apps, settings, etc'
property :munki_client_download_url, String, description: 'The URL where nodes will download the Munki client from'
property :munki_user, String, description: 'A username used to connect to the munki_repo_url with'
property :munki_password, String, description: 'The password associated with the munki_user account'

provides :mac_app_management, platform: 'mac_os_x'

action :install do
  directory '/usr/local/munki' do
    owner 'root'
    group 'wheel'
    mode '0755'
    action :create
  end

  directory '/usr/local/munki/munki_download' do
    owner 'root'
    group 'wheel'
    mode '0755'
    action :create
  end

  download_path = '/usr/local/munki/munki_download/munki.pkg'

  remote_file 'Download Munki Package file' do
    path download_path
    source new_resource.munki_client_download_url
    mode '0644'
    action :create
  end

  execute 'Install munki client' do
    user 'root'
    command "/usr/sbin/installer -pkg #{download_path} -target /"
  end

  unless new_resource.munki_user.nil? && new_resource.munki_password.nil?
    template '/usr/local/munki/munki_download/encode.py' do
      cookbook 'desktop-config'
      source 'encode.py.erb'
      owner 'root'
      group 'wheel'
      mode '0755'
      variables(
        user: new_resource.munki_user,
        pass: new_resource.munki_password
      )
    end

    header_cmd = shell_out('/usr/bin/python', '/usr/local/munki/munki_download/encode.py')
    header_hash = header_cmd.stdout.to_s.split.join(' ')

    execute 'Add Basic Auth Headers to the ManagedInstalls Plist' do
      command "defaults write /Library/Preferences/ManagedInstalls AdditionalHttpHeaders -array \"#{header_hash}\""
      action :run
    end
  end

  macos_userdefaults 'Configure Munki Repo URL' do
    domain '/Library/Preferences/ManagedInstalls'
    key 'SoftwareRepoURL'
    value new_resource.munki_repo_url
    type 'string'
  end
end
