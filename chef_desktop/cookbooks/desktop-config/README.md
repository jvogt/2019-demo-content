# desktop-config

This cookbook is designed for ease of use for Windows and macOS desktop administrators who do not have deep command-line experience or any experience with Ruby or Chef Infra. The main recipes in the cookbook are created around the principles of selecting the settings for something - like you want to enable FileVault or BitLocker drive encryption - and then merely enabling the feature you want to have deployed to your fleet.

## Requirements

### Platforms Supported

- Microsoft Windows 10
- macOS 10.13 and later

### Chef Infra Client

- Chef Infra Client 16+

### Dependencies

- Munki for macOS App management
- Gorilla for Windows 10 App management

## Recipes

### default

This recipe does nothing more than determine what Operating System it is running on and then calls an OS-specific recipe from there.

### windows

The Windows recipe is a series of settings that you can use to decide on that will be enforced on your Windows 10 desktops. Example:

```ruby
disk_encryption 'Turns on BitLocker Drive Encryption' do
  action :enable
  # valid options include :enable, :disable, :nothing
end
```

The emphasis here with this style of recipe is that it is almost plain English and meant to be easy to understand and configure.

### mac

The macOS recipe follows the same format and to the degree possible the exact same spelling and parameters are used so that there is strong consistency between the recipes and no change in verbiage which could lead to confusion. Example:

```ruby
chef_schedule 'Setup the Chef Infra Client to run every 30 minutes' do
  running_interval 30
  action :enable
  # valid options include :enable, :disable
end
```

The code block there is identical to the Windows version. It should be easy to understand and straight forward for administrators.

## Usage

This cookbook uses a Policyfile which is preset to run the cookbook for you. All you have to do is call from the directory above where your desktop-config cookbook lives:

```ruby
chef-client -z -o desktop-config
```

The first step to doing something interesting with this cookbook, however is to go through both the windows and mac recipes and ensure that the default settings are what you want for your deployment.

## Resources

You will notice that many of the resources are prefixed for the operating system they belong to. You will also notice that others are labeled like: (os name) disk_encryption. Those resources that are not prefixed with an operating system label can be used interchangeably between Mac and Windows.

### mac_app_management

The `mac_app_management` resource is used to configure macOS nodes to use a Munki client and retrieve the settings necessary to configure applications for users

<u>Properties:</u>

**munki_repo_url**: The URL of the file share you are hosting you apps and content on

**munki_client_download_url:** The URL where your nodes will download the Munki pkg from

**munki_user**: The user to connect to the munki_repo_url with

**munki_password**: The matching password for that account

<u>Actions</u>:

**install**: Installs the client on the macOS node

**nothing**: The settings will not be set, a noop

### mac_automatic_software_updates

This resource is used to enforce OS level patches and updates get installed on a timely basis.

<u>Properties</u>:

**check**: Tells the OS to check for updates automatically.

**download**: Tells the OS to download the updates

**install_os**: Tells the OS to update OS version updates

**install_app_store**: Tells the OS to install updates to apps installed via the App Store

**install_critical**: Enforces the installation of critical updates like CVE's

### (mac) chef_schedule

Used to enable or disable a LaunchDaemon that runs every 30 minutes to connect to the Chef Infra Server and check for updates.

<u>Properties</u>:

**running_interval**: An amount of time, in minutes you want your Chef Infra Client to run. If you want it to run every 30 minutes, your interval would be 30

**start_time:** Used in the scenario where you need to run the Chef Infra Client at a specific time of day.

<u>Actions</u>:

**enable**: Enable the Chef Infra Client to run at the interval specified above

**disable**: Prevent the Chef Infra Client from running ever

**nothing**: The settings will not be set, a noop

### (mac) desktop_screensaver

Use this to setup a profile that enables a screensaver to come on at a fixed period of inactivity, say 20 minutes, and then requires a password to unlock the desktop again.

<u>Properties</u>:

**idle_time**: Amount of time in minutes of inactivity before the screen saver comes on

**delay_before_password_prompt**: Amount of time in minutes after the screen saver is on before the user needs to logon

**require_password**: True False setting to require a user to logon after the screensaver comes on

**label**; A short-name for your organization to label the screensaver internally with.

<u>Actions</u>:

**enable**: Sets the properties and enables the screen saver

**disable**: Turns off the screensaver

**nothing**: The settings will not be set, a noop

### (mac) disk_encryption

This enables FileVault drive encryption when executed on OS X

<u>Properties</u>:

None:

<u>Actions</u>:

enable: Turns on FileVault

### mac_password_policy

Set password complexity, expire passwords, etc.

<u>Properties</u>:

**max_failed_logins**: The number of times a user can fail to logon before a lockout occurs

**lockout_time**: The amount of time a user must wait after max_failed_logins is reached before they can try to logon again

**maximum_password_age**: Length of time, in days, a password is valid. Default is 365 per NIST standard

**minimum_password_length**: Number of characters long the password should be. Recommend 12

**minimum_numeric_characters**: Number of characters in the password which must be numeric

**minimum_lowercase_letter**: Number of characters in the password which must be lowercase

**minimum_uppercase_letters**: Number of characters in the password which must be uppercase

**minimum_special_characters**: Number of characters in the password which must be special characters

**remember_how_many_passwords**: Number of passwords to keep track of to prevent reuse

**exempt_user**: Admins are exempt by default. Name a user who should not have this policy applied to their account

<u>Actions</u>:

**set**: This action sets the policy as defined in the properties above.

**nothing**: The settings will not be set, a noop

### mac_power_management

Used to put a mac into a type of Kiosk mode where the system never sleeps

<u>Properties</u>:

**computer_sleep_time**: The amount of idle time before the Mac goes to sleep

**display_sleep_time**: The idle time, in minutes, before displays turn off

**disk_sleep_time**: The idle time of a device before it's disk(s) goes to sleep

<u>Actions</u>:

**set**: This action sets the policy as defined in the properties above.

**nothing**:

### (mac) client_reboot

Forces the node to reboot. Works the same on Windows and Mac.

<u>Properties</u>:

**reboot_reason**: Any reason you wish to enter as to why you rebooted. Optional

<u>Actions</u>:

**reboot**: tells the node to reboot

**nothing**: The settings will not be set, a noop

### (mac) rescue_account

Creates an admin account to get access to the device in the event of service requests etc.

<u>Properties</u>:

rescue_account_name: Some name for your user

rescue_account_password: A password to match the rescue account user

<u>Actions</u>:

**create**: Creates the user specified in the property field above

**delete**: Deletes the named user

**enable**: Turns the account on if previously disabled

**disable**: Turns off the account if it was enabled

**nothing**: The settings will not be set, a noop

### (mac) system_preferences

The preferences resource is used to set some system-wide preferences for things like the firewall and when to logout the current user, if ever

<u>Properties</u>:

**firewall**: Ensures that the firewall is enabled.

**autologout**: Set the system to logout due to inactivity

**autologout_time**: The amount of elapsed time to wait before auto-logout executes

**admin_account_control**: Require an admin account to make system-wide changes.

<u>Actions</u>:

**set**: Sets the state of the properties above.

**nothing**: Does nothing

### windows_app_management

Configures the windows device to use a Gorilla client and accept/install apps, patches and updates from the service

<u>Properties</u>:

**how_often_to_check_for_updates**: Options include minute, daily, weekly, monthly, none, once, on_logon, onstart, on_idle.

<u>Actions</u>:

**enable**: Sets the property above, installs Gorilla, configures the the local install with the yaml file and sets a Windows Scheduled Task to run at the interval above

**disable**: Disables the Windows Scheduled Task

**nothing**: The settings will not be set, a noop

### (windows) desktop_screensaver

Use this to setup a screensaver to come on at a fixed period of inactivity, say 20 minutes, and then requires a password to unlock the desktop again.

<u>Properties</u>:

**require_password**: True/false to turn on password protection for the screensaver

**idle_time**: The amount of idle time, in minutes, before the screen saver comes on.

**allow_lower_user_idle_time**: True/false to let users specify a lower idle time. For example, if idle_time is set to 20 minutes, some users might prefer to have their screensaver come on in 10 minutes. This setting will not let users exceed the maximum threshold set via idle-time above.

**screensaver_name**: The screen saver defaults to `mystify` but allows for you to insert a screensaver of your choice. This screensaver MUST be in .SCR format as prescribed by Microsoft.

<u>Actions</u>:

**enable**: Sets up a screensaver on the Windows node per the settings above.

**nothing**: The settings will not be set, a noop

### windows_desktop_winrm_settings

In those cases where you need to directly interact with nodes via winrm ports 5985, or 5986 you would enable this resource. Enabling this also sets a firewall rule to allow traffic to traverse the firewall.

<u>Properties</u>:

None

<u>Actions</u>:

**enable**: Turns on WinRM and sets a firewall policy

**disable**: Turns OFF winrm and disables the firewall policy

**nothing**: The settings will not be set, a noop

### (windows) disk_encryption

This enables or disables BitLocker drive encryption

<u>Properties</u>:

None

<u>Actions</u>:

**enable**: Turns on BitLocker

**disable**: Turns OFF BitLocker

**nothing**: The settings will not be set, a noop

### windows_password_policy

Set password complexity, expire passwords, etc. for Windows nodes

<u>Properties</u>:

**require_complex_passwords**: A true/false switch to require complex passwords (upper. lower, characters, numbers)

**minimum_password_length**: An Integer specifying the number of characters for the password length

**maximum_password_age**: An Integer specifying the maximum number of days for password age

**password_never_expires**: A true/false for setting a non-expiry policy for users

**group_name_for_password_never_expires**: The local group of users to whom the password_never_expires is assigned. It defaults to Administrators.

**change_password_at_next_logon**: True/false to kill passwords and force users to create a new one.

**group_name_for_expired_passwords**: The name of the local group who is expected to change their password at the next logon

<u>Actions</u>:

**set**: Sets the password policy using the properties above

**nothing**: The settings will not be set, a noop

### windows_power_management

Set power management settings for devices so they don't go to sleep or lose battery power. This is not for a true Kiosk mode but designed for tablets and/or other devices used in a normal office that need to stay on.

<u>Properties</u>:

**power_scheme_label**: A label to preface the power level name with. This is to differentiate your settings from stock Windows settings. The label will be visible in Control Panel under Power Options

**power_level**: There are 2 choices here, 'balanced' or 'ultimate' - note the case sensitivity.

<u>Actions</u>:

**set**: Use this to set the power scheme on a node to balanced or ultimate.

**nothing**: The settings will not be set, a noop

### (windows) client_reboot

Forces the node to reboot

<u>Properties</u>:

**reboot_reason**: Optional - Specify why you are rebooting the node

<u>Actions</u>:

**reboot**: Reboots the node 2 minutes after it finishes converging.

**nothing**: The settings will not be set, a noop

### (windows) rescue_account

Creates an admin account of your choosing to get access to the device in the event of service requests etc.

<u>Properties</u>:

**rescue_account_name**: The username you want for a recovery account

**rescue_account_password**: The password for that user account. This password must conform to the Password Policy rules you set previously

<u>Actions</u>:

**create**: Sets a rescue account based on the properties above

**nothing**: The settings will not be set, a noop

### (windows) system_preferences

A resource to help lockout and secure the firewall, AV, and other services

<u>Properties</u>:

**firewall**: Turns on the firewall.

**autologout**: Set this to logout the current user after an inactivity period

**autologout_time**: The amount of time to pass before the account is logged out.

**admin_account_control**: Require an admin account to make system changes

<u>Actions</u>:

**set**:

**nothing**:

### windows_update_settings

Configures Windows to accept updates, auto-install some too.

**disable_os_upgrades**: Prevents Windows from Updating the OS
**elevate_non_admins**: Automatically elevate the local user to Admin to install a given patch.
**add_to_target_wsus_group**: If you have WSUS installation, you could add this node to a WSUS deploy group
**target_wsus_group_name**: If you wanted to add your node to a target group, what is that name?
**wsus_server_url**: The URL for connecting to your WSUS server
**wsus_status_server_url**: The URL for your WSUS Status server
**block_windows_update_website:** Block or enable access to Windows Update for updates and patches
**automatic_update_option**: Tells Windows how and when to download an update.
**automatically_install_minor_updates**: Do you want to install patches or just major updates?
**enable_detection_frequency**: Turns on the ability to check for updates more frequently
**custom_detection_frequency**: The maximum number of hours to pass before the next check for updates occurs.
**no_reboot_with_users_logged_on**: Enables or Prevents the OS from rebooting post-install if a user is logged on to the console.
**disable_automatic_updates**: Don't automatically check for updates.
**scheduled_install_day**: A specific day of the week to install updates on
**scheduled_install_hour**: A specific time to install updates at.
**update_other_ms_products**: Do you want to update only the Operating System or all the other Microsoft apps too?
**use_custom_update_server:** Tells the node to use a WSUS server instead of Windows Update

<u>Properties</u>:

<u>Actions</u>:

**enable**: Overrides default settings with these custom options.

**nothing**: The settings will not be set, a noop

## License

**Copyright:** 2020, Chef Software, Inc.

**License** [Chef MLSA License](https://www.chef.io/online-master-agreement/)
