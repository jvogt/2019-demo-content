# encoding: UTF-8

control "xccdf_org.cisecurity.benchmarks_rule_1.1_Verify_all_Apple_provided_software_is_current" do
  title "Verify all Apple provided software is current"
  desc  "
    Software vendors release security patches and software updates for their products when security vulnerabilities are discovered. There is no simple way to complete this action without a network connection to an Apple software repository. Please ensure appropriate access for this control. This check is only for what Apple provides through software update.
    
    Rationale: It is important that these updates be applied in a timely manner to prevent unauthorized persons from exploiting the identified vulnerabilities.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Ensure Software is up to date\n# \n\noutput=$(\nsoftwareupdate -l\n)\n\n# If result returns software updates fail, otherwise pass.\nif [ \"$output\" == *\"Software Update found the following new or updated software:\"* ]; then\n\techo \"$output\"\n    exit 1\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 0\nfi\n\n\noutput=$(softwareupdate -l)") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_1.2_Enable_Auto_Update" do
  title "Enable Auto Update"
  desc  "
    Auto Update verifies that your system has the newest security patches and software updates. If \"Automatically check for updates\" is not selected background updates for new malware definition files from Apple for XProtect and Gatekeeper will not occur.
    
    http://macops.ca/os-x-admins-your-clients-are-not-getting-background-security-updates/
    
    https://derflounder.wordpress.com/2014/12/17/forcing-xprotect-blacklist-updates-on-mavericks-and-yosemite/
    
    Rationale: It is important that a system has the newest updates applied so as to prevent unauthorized persons from exploiting identified vulnerabilities.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.SoftwareUpdate.plist', xpath: 'name(/plist/dict/key[text()=\'AutomaticCheckEnabled\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_1.3_Enable_app_update_installs" do
  title "Enable app update installs"
  desc  "
    Ensure that application updates are installed after they are available from Apple. These updates do not require reboots or admin privileges for end users.
    
    Rationale: Patches need to be applied in a timely manner to reduce the risk of vulnerabilities being exploited
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.commerce.plist', xpath: 'name(/plist/dict/key[text()=\'AutoUpdate\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_1.4_Enable_system_data_files_and_security_update_installs" do
  title "Enable system data files and security update installs"
  desc  "
    Ensure that system and security updates are installed after they are available from Apple. This setting enables definition updates for XProtect and Gatekeeper, with this setting in place new malware and adware that Apple has added to the list of malware or untrusted software will not execute. These updates do not require reboots or end user admin rights.
    
    http://www.thesafemac.com/tag/xprotect/
    
    https://support.apple.com/en-us/HT202491
    
    Rationale: Patches need to be applied in a timely manner to reduce the risk of vulnerabilities being exploited
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.SoftwareUpdate.plist', xpath: 'name(/plist/dict/key[text()=\'ConfigDataInstall\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
  describe plist('/Library/Preferences/com.apple.SoftwareUpdate.plist', xpath: 'name(/plist/dict/key[text()=\'CriticalUpdateInstall\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_1.5_Enable_macOS_update_installs" do
  title "Enable macOS update installs"
  desc  "
    Ensure that macOS updates are installed after they are available from Apple. This setting enables macOS updates to be automatically installed. Some environments will want to approve and test updates before they are delivered. It is best practice to test first where updates can and have caused disruptions to operations. Automatic updates should be turned off where changes are tightly controlled and there are mature testing and approval processes. Automatic updates should not be turned off so the admin can call the users first to let them know it's ok to install. A dependable repeatable process involving a patch agent or remote management tool should be in place before auto-updates are turned off.
    
    Rationale: Patches need to be applied in a timely manner to reduce the risk of vulnerabilities being exploited
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.commerce.plist', xpath: 'name(/plist/dict/key[text()=\'AutoUpdateRestartRequired\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.1.1_Turn_off_Bluetooth_if_no_paired_devices_exist" do
  title "Turn off Bluetooth, if no paired devices exist"
  desc  "
    Bluetooth devices use a wireless communications system that replaces the cables used by other peripherals to connect to a system. It is by design a peer-to-peer network technology and typically lacks centralized administration and security enforcement infrastructure.
    
    Rationale: Bluetooth is particularly susceptible to a diverse set of security vulnerabilities involving identity detection, location tracking, denial of service, unintended control and access of data and voice channels, and unauthorized device control and data access.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.Bluetooth.plist', xpath: '/plist/dict/key[text()=\'ControllerPowerState\']/following-sibling::*[1]/text()') do
    it { should exist }
    its("xpath_value") { should cmp 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.1.2_Bluetooth_Discoverable_is_only_available_when_Bluetooth_preference_pane_is_open" do
  title "Bluetooth \"Discoverable\" is only available when Bluetooth preference pane is open"
  desc  "
    When Bluetooth is set to discoverable mode, the Mac sends a signal indicating that it's available to pair with another Bluetooth device. When a device is \"discoverable\" it broadcasts information about itself and its location. Starting with OS X 10.9 Discoverable mode is enabled only while the Bluetooth System Preference is open and turned off once closed.
    
    Rationale: When in the discoverable state an unauthorized user could gain access to the system by pairing it with a remote device.
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.1.3_Show_Bluetooth_status_in_menu_bar" do
  title "Show Bluetooth status in menu bar"
  desc  "
    By showing the Bluetooth status in the menu bar, a small Bluetooth icon is placed in the menu bar. This icon quickly shows the status of Bluetooth, and can allow the user to quickly turn Bluetooth on or off.
    
    Rationale: Enabling \"Show Bluetooth status in menu bar\" is a security awareness method that helps understand the current state of Bluetooth, including whether it is enabled, Discoverable, what paired devices exist and are currently active.
  "
  impact 1.0
  describe plist('$HOME/Library/Preferences/com.apple.systemuiserver.plist', xpath: '/plist/dict/key[.=\'menuExtras\']/following-sibling::*[1]/string[.=\'/System/Library/CoreServices/Menu Extras/Bluetooth.menu\']/text()') do
    it { should exist }
    its("xpath_value") { should cmp "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.2.1_Enable_Set_time_and_date_automatically" do
  title "Enable \"Set time and date automatically\""
  desc  "
    Correct date and time settings are required for authentication protocols, file creation, modification dates and log entries.
    
    Note: If your organization has internal time servers, enter them here. Enterprise mobile devices may need to use a mix of internal and external time servers. If multiple servers are required use the Date  Time System Preference with each server separated by a space.
    
    Rationale: Kerberos may not operate correctly if the time on the Mac is off by more than 5 minutes. This in turn can affect Apple's single sign-on feature, Active Directory logons, and other features.
  "
  impact 1.0
  describe command('systemsetup -getusingnetworktime') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/On$/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.2.2_Ensure_time_set_is_within_appropriate_limits" do
  title "Ensure time set is within appropriate limits"
  desc  "
    Correct date and time settings are required for authentication protocols, file creation, modification dates and log entries. Ensure that time on the computer is within acceptable limits. Truly accurate time is measured within milliseconds, for this audit a drift under four and a half minutes passes the control check. Since Kerberos is one of the important features of macOS integration into Directory systems the guidance here is to warn you before there could be an impact to operations. From the perspective of accurate time this check is not strict, it may be too great for your organization, adjust to a smaller offset value as needed.
    
    Rationale: Kerberos may not operate correctly if the time on the Mac is off by more than 5 minutes. This in turn can affect Apple's single sign-on feature, Active Directory logons, and other features. Audit check is for more than 4 minutes and 30 seconds ahead or behind.
  "
  impact 1.0
  describe command('systemsetup -getusingnetworktime') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/On$/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.3.1_Set_an_inactivity_interval_of_20_minutes_or_less_for_the_screen_saver" do
  title "Set an inactivity interval of 20 minutes or less for the screen saver"
  desc  "
    A locking screensaver is one of the standard security controls to limit access to a computer and the current user's session when the computer is temporarily unused or unattended. In macOS the screensaver starts after a value selected in a drop down menu, 10 minutes and 20 minutes are both options and either is acceptable. Any value can be selected through the command line or script but a number that is not reflected in the GUI can be problematic. 20 minutes is the default for new accounts.
    
    Rationale: Setting an inactivity interval for the screensaver prevents unauthorized persons from viewing a system left unattended for an extensive period of time.
  "
  impact 1.0
  describe.one do
    describe plist('$HOME/Library/Preferences/com.apple.screensaver.plist', xpath: '/plist/dict/key[text()=\'idleTime\']/following-sibling::*[1]/text()') do
      it { should exist }
      its("xpath_value") { should cmp 600 }
    end
    describe plist('$HOME/Library/Preferences/com.apple.screensaver.plist', xpath: '/plist/dict/key[text()=\'idleTime\']/following-sibling::*[1]/text()') do
      it { should exist }
      its("xpath_value") { should cmp 1200 }
    end
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.3.3_Familiarize_users_with_screen_lock_tools_or_corner_to_Start_Screen_Saver" do
  title "Familiarize users with screen lock tools or corner to Start Screen Saver"
  desc  "
    In 10.13 Apple added a \"Lock Screen\" option to the Apple Menu. Prior to this the best quick lock options were to use either a lock screen option with the screen saver or the lock screen option from Keychain Access if status was made available in the menu bar. With 10.13 the menu bar option is no longer available.
    The intent of this control is to resemble control-alt-delete on Windows Systems as a means of quickly locking the screen. If the user of the system is stepping away from the computer the best practice is to lock the screen and setting a hot corner is an appropriate method.
    
    Rationale: Ensuring the user has a quick method to lock their screen may reduce opportunity for individuals in close physical proximity of the device to see screen contents.
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.1_Disable_Remote_Apple_Events" do
  title "Disable Remote Apple Events"
  desc  "
    Apple Events is a technology that allows one program to communicate with other programs. Remote Apple Events allows a program on one computer to communicate with a program on a different computer.
    
    Rationale: Disabling Remote Apple Events mitigates the risk of an unauthorized program gaining access to the system.
  "
  impact 1.0
  describe command('systemsetup -getremoteappleevents') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/Off$/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.2_Disable_Internet_Sharing" do
  title "Disable Internet Sharing"
  desc  "
    Internet Sharing uses the open source natd process to share an internet connection with other computers and devices on a local network. This allows the Mac to function as a router and share the connection to other, possibly unauthorized, devices.
    
    Rationale: Disabling Internet Sharing reduces the remote attack surface of the system.
  "
  impact 1.0
  describe.one do
    describe plist('/Library/Preferences/SystemConfiguration/com.apple.nat.plist', xpath: '/plist/dict/key/following-sibling::*[1]/key[text()=\'Enabled\']/following-sibling::*[1]/text()') do
      it { should exist }
      its("xpath_value") { should cmp 0 }
    end
    describe file("/Library/Preferences/SystemConfiguration/com.apple.nat") do
      it { should_not exist }
    end
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.3_Disable_Screen_Sharing" do
  title "Disable Screen Sharing"
  desc  "
    Screen sharing allows a computer to connect to another computer on a network and display the computer&#x2019;s screen. While sharing the computer&#x2019;s screen, the user can control what happens on that computer, such as opening documents or applications, opening, moving, or closing windows, and even shutting down the computer.
    
    Rationale: Disabling screen sharing mitigates the risk of remote connections being made without the user of the console knowing that they are sharing the computer.
  "
  impact 1.0
  describe plist('/System/Library/LaunchDaemons/com.apple.screensharing.plist', xpath: 'name(/plist/dict/key[text()=\'Disabled\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.4_Disable_Printer_Sharing" do
  title "Disable Printer Sharing"
  desc  "
    By enabling Printer sharing the computer is set up as a print server to accept print jobs from other computers. Dedicated print servers or direct IP printing should be used instead.
    
    Rationale: Disabling Printer Sharing mitigates the risk of attackers attempting to exploit the print server to gain access to the system.
  "
  impact 1.0
  describe command('system_profiler SPPrintersDataType -xml | xpath "/plist/array[1]/dict[1]/key[.=\'_items\']/following-sibling::array[1]/dict/key[.=\'shared\']/following-sibling::*[1]"') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/<string>no<\/string>/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.5_Disable_Remote_Login" do
  title "Disable Remote Login"
  desc  "
    Remote Login allows an interactive terminal connection to a computer.
    
    Rationale: Disabling Remote Login mitigates the risk of an unauthorized person gaining access to the system via Secure Shell (SSH). While SSH is an industry standard to connect to posix servers, the scope of the benchmark is for Apple macOS clients, not servers.
    
    macOS does have an IP based firewall available (pf, ipfw has been deprecated) that is not enabled or configured. There are more details and links in section 7.5. macOS no longer has TCP Wrappers support built-in and does not have strong Brute-Force password guessing mitigations, or frequent patching of openssh by Apple. Most macOS computers are mobile workstations, managing IP based firewall rules on mobile devices can be very resource intensive. All of these factors can be parts of running a hardened SSH server.
  "
  impact 1.0
  describe command('systemsetup -getremotelogin') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/Off$/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.6_Disable_DVD_or_CD_Sharing" do
  title "Disable DVD or CD Sharing"
  desc  "
    DVD or CD Sharing allows users to remotely access the system's optical drive.
    
    Rationale: Disabling DVD or CD Sharing minimizes the risk of an attacker using the optical drive as a vector for attack and exposure of sensitive data.
  "
  impact 1.0
  describe plist('/System/Library/LaunchDaemons/com.apple.ODSAgent.plist', xpath: 'name(/plist/dict/key[text()=\'Disabled\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.7_Disable_Bluetooth_Sharing" do
  title "Disable Bluetooth Sharing"
  desc  "
    Bluetooth Sharing allows files to be exchanged with Bluetooth enabled devices.
    
    Rationale: Disabling Bluetooth Sharing minimizes the risk of an attacker using Bluetooth to remotely attack the system.
  "
  impact 1.0
  describe command('system_profiler SPBluetoothDataType -xml | xpath "/plist/array[1]/dict[1]/key[.=\'_items\']/following-sibling::*[1]/dict/key[.=\'services_title\']/following-sibling::*[1]/dict/key/following-sibling::*[1]/key[.=\'service_state\']/following-sibling::*[1]"') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/<string>attrib_disabled<\/string>/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.8_Disable_File_Sharing" do
  title "Disable File Sharing"
  desc  "
    Apple's File Sharing uses a combination of SMB (Windows sharing) and AFP (Mac sharing)
    
    Two common ways to share files using File Sharing are:
    
    * Apple File Protocol (AFP) AFP automatically uses encrypted logins, so this method of sharing files is fairly secure. The entire hard disk is shared to administrator user accounts. Individual home folders are shared to their respective user accounts. Users' \"Public\" folders (and the \"Drop Box\" folder inside) are shared to any user account that has sharing access to the computer (i.e. anyone in the \"staff\" group, including the guest account if it is enabled).
    * Server Message Block (SMB), Common Internet File System (CIFS) When Windows (or possibly Linux) computers need to access file shared on a Mac, SMB/CIFS file sharing is commonly used. Apple warns that SMB sharing stores passwords is a less secure fashion than AFP sharing and anyone with system access can gain access to the password for that account. When sharing with SMB, each user that will access the Mac must have SMB enabled.
    
    Rationale: By disabling file sharing, the remote attack surface and risk of unauthorized access to files stored on the system is reduced.
  "
  impact 1.0
  describe plist('/System/Library/LaunchDaemons/com.apple.AppleFileServer.plist', xpath: 'name(/plist/dict/key[text()=\'Disabled\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
  describe plist('/System/Library/LaunchDaemons/com.apple.smbd.plist', xpath: 'name(/plist/dict/key[text()=\'Disabled\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.4.9_Disable_Remote_Management" do
  title "Disable Remote Management"
  desc  "
    Remote Management is the client portion of Apple Remote Desktop (ARD). Remote Management can be used by remote administrators to view the current Screen, install software, report on, and generally manage client Macs.
    
    The screen sharing options in Remote Management are identical to those in the Screen Sharing section. In fact, only one of the two can be configured. If Remote Management is used, refer to the Screen Sharing section above on issues regard screen sharing.
    
    Remote Management should only be enabled when a Directory is in place to manage the accounts with access. Computers will be available on port 5900 on a macOS System and could accept connections from untrusted hosts depending on the configuration, definitely a concern for mobile systems.
    
    Rationale: Remote management should only be enabled on trusted networks with strong user controls present in a Directory system. Mobile devices without strict controls are vulnerable to exploit and monitoring.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Disable Remote Management\n# \n\noutput=$(\nps -ef | egrep ARDAgent\n)\n\n# If result returns fail, otherwise pass.\nif [ \"$output\" == *\"/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents\"* ] ; then\n\techo \"$output\"\n    exit 1\nelse\n    # passing\n    echo \"$output\"\n    exit 0\nfi\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.5.1_Disable_Wake_for_network_access" do
  title "Disable \"Wake for network access\""
  desc  "
    This feature allows other users to be able to access your computer&#x2019;s shared resources, such as shared printers or iTunes playlists, even when your computer is in sleep mode. In a closed network when only authorized devices could wake a computer it could be valuable to wake computers in order to do management push activity. Where mobile workstations and agents exist the device will more likely check in to receive updates when already awake. Mobile devices should not be listening for signals on unmanaged network where untrusted devices could send wake signals.
    
    Rationale: Disabling this feature mitigates the risk of an attacker remotely waking the system and gaining access.
  "
  impact 1.0
  describe command('systemsetup -getwakeonnetworkaccess') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/Off$/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.6.1.1_Enable_FileVault" do
  title "Enable FileVault"
  desc  "
    FileVault secures a system's data by automatically encrypting its boot volume and requiring a password or recovery key to access it.
    
    Rationale: Encrypting sensitive data minimizes the likelihood of unauthorized users gaining access to it.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Ensure FireVault is enabled\n# \n\noutput=$(\nfdesetup status\n)\n\n# If result returns it is enabled pass, otherwise fail.\nif [ \"$output\" == \"FileVault is On.\" ] ; then\n\techo \"$output\"\n    exit 0\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 1\nfi\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.6.1.2_Ensure_all_user_storage_APFS_volumes_are_encrypted" do
  title "Ensure all user storage APFS volumes are encrypted"
  desc  "
    Apple developed a new file system that was first made available in 10.12 and then became the default in 10.13. The file system is optimized for Flash and Solid State storage and encryption.
    https://en.wikipedia.org/wiki/Apple_File_System
    macOS computers generally have several volumes created as part of APFS formatting including Preboot, Recovery and Virtual Memory (VM) as well as traditional user disks.
    
    All APFS volumes that do not have specific roles that do not require encryption should be encrypted. \"Role\" disks include Preboot, Recovery and VM. User disks are labelled with \"(No specific role)\" by default.
    
    Rationale: In order to protect user data from loss or tampering volumes carrying data should be encrypted
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.6.1.3_Ensure_all_user_storage_CoreStorage_volumes_are_encrypted" do
  title "Ensure all user storage CoreStorage volumes are encrypted"
  desc  "
    Apple introduced Core Storage with 10.7. It is used as the default for formatting on macOS volumes prior to 10.13.
    
    All HFS and Core Storage Volumes should be encrypted
    
    Rationale: In order to protect user data from loss or tampering volumes carrying data should be encrypted
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.6.2_Enable_Gatekeeper" do
  title "Enable Gatekeeper"
  desc  "
    Gatekeeper is Apple's application white-listing control that restricts downloaded applications from launching. It functions as a control to limit applications from unverified sources from running without authorization.
    
    Rationale: Disallowing unsigned software will reduce the risk of unauthorized or malicious applications from running on the system.
  "
  impact 1.0
  describe command('spctl --status') do
    its("stdout") { should eq "assessments enabled" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.6.3_Enable_Firewall" do
  title "Enable Firewall"
  desc  "
    A firewall is a piece of software that blocks unwanted incoming connections to a system. Apple has posted general documentation about the application firewall.
    
    [http://support.apple.com/en-us/HT201642](http://support.apple.com/en-us/HT201642)
    
    Rationale: A firewall minimizes the threat of unauthorized users from gaining access to your system while connected to a network or the Internet.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.alf.plist', xpath: '/plist/dict/key[text()=\'globalstate\']/following-sibling::*[1]/text()') do
    it { should exist }
    its("xpath_value") { should cmp >= 1 }
  end
  describe plist('/Library/Preferences/com.apple.alf.plist', xpath: '/plist/dict/key[text()=\'globalstate\']/following-sibling::*[1]/text()') do
    it { should exist }
    its("xpath_value") { should cmp <= 2 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.6.4_Enable_Firewall_Stealth_Mode" do
  title "Enable Firewall Stealth Mode"
  desc  "
    While in Stealth mode the computer will not respond to unsolicited probes, dropping that traffic.
    
    [http://support.apple.com/en-us/HT201642](http://support.apple.com/en-us/HT201642)
    
    Rationale: Stealth mode on the firewall minimizes the threat of system discovery tools while connected to a network or the Internet.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.alf.plist', xpath: '/plist/dict/key[text()=\'stealthenabled\']/following-sibling::*[1]/text()') do
    it { should exist }
    its("xpath_value") { should cmp 1 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.6.5_Review_Application_Firewall_Rules" do
  title "Review Application Firewall Rules"
  desc  "
    A firewall is a piece of software that blocks unwanted incoming connections to a system. Apple has posted general documentation about the application firewall.
    
    [http://support.apple.com/en-us/HT201642](http://support.apple.com/en-us/HT201642)
    
    A computer should have a limited number of applications open to incoming connectivity. This rule will check for whether there are more than 10 rules for inbound connections.
    
    Rationale: A firewall minimizes the threat of unauthorized users from gaining access to your system while connected to a network or the Internet. Which applications are allowed access to accept incoming connections through the firewall is important to understand.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Review Application Firewall Rules\n# \n\noutput=$(\n/usr/libexec/ApplicationFirewall/socketfilterfw --listapps | grep ALF | awk '{print $7}'\n)\n\n# If 10 or less pass, otherwise fail.\nif [ \"$output\" -le 10 ] ; then\n\techo \"$output\"\n    exit 0\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 1\nfi\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.8.2_Time_Machine_Volumes_Are_Encrypted" do
  title "Time Machine Volumes Are Encrypted"
  desc  "
    One of the most important security tools for data protection on macOS is FileVault. With encryption in place it makes it difficult for an outside party to access your data if they get physical possession of the computer. One very large weakness in data protection with FileVault is the level of protection on backup volumes. If the internal drive is encrypted but the external backup volume that goes home in the same laptop bag is not it is self-defeating. Apple tries to make this mistake easily avoided by providing a checkbox to enable encryption when setting-up a time machine backup. Using this option does require some password management, particularly if a large drive is used with multiple computers. A unique complex password to unlock the drive can be stored in keychains on multiple systems for ease of use.
    
    While some portable drives may contain non-sensitive data and encryption may make interoperability with other systems difficult backup volumes should be protected just like boot volumes.
    
    Rationale: Backup volumes need to be encrypted
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Ensure Time Machine Volumes Are Encrypted\n# \n\noutput=$(\ntmutil destinationinfo | grep -i NAME\n)\n\n# If results returns pass, otherwise fail.\n# if [ \"$output\" == *\"Name\"* ] ; then\n# \techo \"$output\"\n#     exit 0\n# else\n#     # print the reason why we are failing\n#     echo \"$output\"\n#     exit 1\n# fi\necho \"$output\"\nexit 0") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.9_Pair_the_remote_control_infrared_receiver_if_enabled" do
  title "Pair the remote control infrared receiver if enabled"
  desc  "
    An infrared receiver is a piece of hardware that sends information from an infrared remote control to another device by receiving and decoding signals. If a remote is used with a computer, a specific remote, or \"pair\", can be set-up to work with the computer. This will allow only the paired remote to work on that computer. If a remote is needed the receiver should only be accessible by a paired device. Many models do not have infrared hardware. The audit check looks for the hardware first.
    
    Rationale: An infrared remote can be used from a distance to circumvent physical security controls. A remote could also be used to page through a document or presentation, thus revealing sensitive information.
  "
  impact 1.0
  describe.one do
    describe plist('/Library/Preferences/com.apple.driver.AppleIRController.plist', xpath: 'name(/plist/dict/key[text()=\'DeviceEnabled\']/following-sibling::*[1])') do
      it { should exist }
      its("xpath_value") { should cmp "false" }
    end
    describe plist('/Library/Preferences/com.apple.driver.AppleIRController', xpath: 'name(/plist/dict/key[text()=\'DeviceEnabled\']/following-sibling::*[1])') do
      it { should exist }
      its("xpath_value") { should cmp "true" }
    end
    describe plist('/Library/Preferences/com.apple.driver.AppleIRController', xpath: '/plist/dict/key[text()=\'UIDFilter\']/following-sibling::*[1]/text()') do
      it { should exist }
      its("xpath_value") { should_not cmp "none" }
    end
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.10_Enable_Secure_Keyboard_Entry_in_terminal.app" do
  title "Enable Secure Keyboard Entry in terminal.app"
  desc  "
    Secure Keyboard Entry prevents other applications on the system and/or network from detecting and recording what is typed into Terminal.
    
    Rationale: Enabling Secure Keyboard Entry minimizes the risk of a key logger from detecting what is entered in Terminal.
  "
  impact 1.0
  describe plist('$HOME/Library/Preferences/com.apple.Terminal.plist', xpath: 'name(/plist/dict/key[text()=\'SecureKeyboardEntry\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_2.13_Ensure_EFI_version_is_valid_and_being_regularly_checked" do
  title "Ensure EFI version is valid and being regularly checked"
  desc  "
    In order to mitigate firmware attacks Apple has created a automated Firmware check to ensure that the EFI version running is a known good version from Apple. There is also an automated process to check it every seven days.
    
    Rationale: If the Firmware of a computer has been compromised the Operating System that the Firmware loads cannot be trusted either.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Ensure EFI version is valid and being regularly checked\n# \n\noutput=$(\n/usr/libexec/firmwarecheckers/eficheck/eficheck --integrity-check |  awk 'NR==2'\n)\n\n# If result contains string pass, otherwise fail.\nif [ \"$output\" == \"Primary allowlist version match found. No changes detected in primary hashes.\" ] ; then\n\techo \"$output\"\n    exit 0\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 1\nfi\n\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_3.1_Enable_security_auditing" do
  title "Enable security auditing"
  desc  "
    macOS's audit facility, auditd, receives notifications from the kernel when certain system calls, such as open, fork, and exit, are made. These notifications are captured and written to an audit log.
    
    Rationale: Logs generated by auditd may be useful when investigating a security incident as they may help reveal the vulnerable application and the actions taken by a malicious actor.
  "
  impact 1.0
  tag cis_issue_ref: "https://workbench.cisecurity.org/benchmarks/806/tickets/9023"
  describe plist('/System/Library/LaunchDaemons/com.apple.auditd.plist', xpath: '/plist/dict/key[text()=\'Label\']/following-sibling::*[1]/text()') do
    it { should exist }
    its("xpath_value") { should cmp "com.apple.auditd" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_3.3_Ensure_security_auditing_retention" do
  title "Ensure security auditing retention"
  desc  "
    The macOS audit capability contains important information to investigate security or operational issues. This resource is only completely useful if it is retained long enough to allow technical staff to find the root cause of anomalies in the records.
    
    Retention can be set to respect both size and longevity. To retain as much as possible under a certain size the recommendation is to use:
    
    expire-after:60d OR 1G
    
    More info in the man page
    man audit_control
    
    Rationale: The audit records need to be retained long enough to be reviewed as necessary.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Ensure security auditing retention\n# \n\noutput=$(\nsudo cat /etc/security/audit_control | egrep expire-after\n)\n\n# If either result returns pass, otherwise fail.\nif [ \"$output\" == \"expire-after:60D\" ] || [ \"$output\" == \"expire-after:1G\" ] ; then\n\techo \"$output\"\n    exit 0\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 1\nfi\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_3.4_Control_access_to_audit_records" do
  title "Control access to audit records"
  desc  "
    The audit system on macOS writes important operational and security information that can be both useful for an attacker and a place for an attacker to attempt to obfuscate unwanted changes that were recorded. As part of defense-in-depth the /etc/security/audit_control configuration and the files in /var/audit should be owned only by root with group wheel with read only rights and no other access allowed. macOS ACLs should not be used for these files.
    
    Rationale: Audit records should never be changed except by the system daemon posting events. Records may be viewed or extracts manipulated but the authoritative files should be protected from unauthorized changes.
  "
  impact 1.0
  describe file("/etc/security/audit_control/^*$") do
    it { should exist }
  end
  describe file("/etc/security/audit_control/^*$") do
    it { should_not be_executable.by "group" }
  end
  describe file("/etc/security/audit_control/^*$") do
    it { should_not be_writable.by "group" }
  end
  describe file("/etc/security/audit_control/^*$") do
    it { should_not be_executable.by "other" }
  end
  describe file("/etc/security/audit_control/^*$") do
    it { should_not be_readable.by "other" }
  end
  describe file("/etc/security/audit_control/^*$") do
    it { should_not be_writable.by "other" }
  end
  describe file("/etc/security/audit_control/^*$") do
    it { should_not be_executable.by "owner" }
  end
  describe file("/etc/security/audit_control/^*$") do
    its("uid") { should cmp 0 }
  end
  describe file("/etc/security/audit_control/^*$") do
    it { should_not be_writable.by "owner" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_3.5_Retain_install.log_for_365_or_more_days" do
  title "Retain install.log for 365 or more days"
  desc  "
    macOS writes information pertaining to system-related events to the file /var/log/install.log and has a configurable retention policy for this file. The default logging setting limits the file size of the logs and the maximum size for all logs. The default allows for an errant application to fill the log files and does not enforce sufficient log retention. The Benchmark recommends a value based on standard use cases. The value should align with local requirements within the organization.
    
    The default value has an \"all_max\" file limitation, no reference to a minimum retention and a less precise rotation argument.
    
    * The maximum file size limitation string should be removed \"all_max=\"
    * An organization appropriate retention should be added \"ttl=\"
    * The rotation should be set with time stamps \"rotate=utc\" or \"rotate=local\"
    
    Rationale: Archiving and retaining install.log for at least a year is beneficial in the event of an incident as it will allow the user to view the various changes to the system along with the date and time they occurred.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Retain install.log for 365 or more days\n# \n\noutput=$(\ngrep -i ttl /etc/asl/com.apple.install  \n)\n\n# If results returns pass, otherwise fail.\nif [ \"$output\" == \"* file /var/log/install.log mode=0640 format=bsd rotate=utc compress file_max=5M ttl=365\" ] ; then\n\techo \"$output\"\n    exit 0\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 1\nfi\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_3.6_Ensure_Firewall_is_configured_to_log" do
  title "Ensure Firewall is configured to log"
  desc  "
    The socketfilter firewall is what is used when the firewall is turned on in the Security PreferencePane. In order to appropriately monitor what access is allowed and denied logging must be enabled.
    
    Rationale: In order to troubleshoot the successes and failures of a firewall logging should be enabled.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.alf.plist', xpath: '/plist/dict/key[text()=\'loggingenabled\']/following-sibling::*[1]/text()') do
    it { should exist }
    its("xpath_value") { should cmp 1 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_4.2_Enable_Show_Wi-Fi_status_in_menu_bar" do
  title "Enable \"Show Wi-Fi status in menu bar\""
  desc  "
    The Wi-Fi status in the menu bar indicates if the system's wireless internet capabilities are enabled. If so, the system will scan for available wireless networks to connect to. At the time of this revision all computers Apple builds have wireless network capability, which has not always been the case. This control only pertains to systems that have a wireless NIC available. Operating systems running in a virtual environment may not score as expected either.
    
    Rationale: Enabling \"Show Wi-Fi status in menu bar\" is a security awareness method that helps mitigate public area wireless exploits by making the user aware of their wireless connectivity status.
  "
  impact 1.0
  describe plist('$HOME/Library/Preferences/com.apple.systemuiserver.plist', xpath: '/plist/dict/key[.=\'menuExtras\']/following-sibling::*[1]/string[.=\'/System/Library/CoreServices/Menu Extras/AirPort.menu\']/text()') do
    it { should exist }
    its("xpath_value") { should cmp "/System/Library/CoreServices/Menu Extras/AirPort.menu" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_4.4_Ensure_http_server_is_not_running" do
  title "Ensure http server is not running"
  desc  "
    macOS used to have a graphical front-end to the embedded Apache web server in the Operating System. Personal web sharing could be enabled to allow someone on another computer to download files or information from the user's computer. Personal web sharing from a user endpoint has long been considered questionable and Apple has removed that capability from the GUI. Apache however is still part of the Operating System and can be easily turned on to share files and provide remote connectivity to an end user computer. Web sharing should only be done through hardened web servers and appropriate cloud services.
    
    Rationale: Web serving should not be done from a user desktop. Dedicated webservers or appropriate cloud storage should be used. Open ports make it easier to exploit the computer.
  "
  impact 1.0
  describe plist('/System/Library/LaunchDaemons/org.apache.httpd.plist', xpath: 'name(/plist/dict/key[text()=\'Disabled\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_4.5_Ensure_nfs_server_is_not_running" do
  title "Ensure nfs server is not running"
  desc  "
    macOS can act as an NFS fileserver. NFS sharing could be enabled to allow someone on another computer to mount shares and gain access to information from the user's computer. File sharing from a user endpoint has long been considered questionable and Apple has removed that capability from the GUI. NFSD is still part of the Operating System and can be easily turned on to export shares and provide remote connectivity to an end user computer.
    
    Rationale: File serving should not be done from a user desktop, dedicated servers should be used. Open ports make it easier to exploit the computer.
  "
  impact 1.0
  describe file("/etc/exports") do
    it { should_not exist }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.1.1_Secure_Home_Folders" do
  title "Secure Home Folders"
  desc  "
    By default macOS allows all valid users into the top level of every other users home folder, and restricts access to the Apple default folders within. Another user on the same system can see you have a \"Documents\" folder but cannot see inside it. This configuration does work for personal file sharing but can expose user files to standard accounts on the system.
    
    The best parallel for Enterprise environments is that everyone who has a Dropbox account can see everything that is at the top level but can't see your pictures, in the parallel with macOS they can see into every new Directory that is created because of the default permissions.
    
    Home folders should be restricted to access only by the user. Sharing should be used on dedicated servers or cloud instances that are managing access controls. Some environments may encounter problems if execute rights are removed as well as read and write. Either no access or execute only for group or others is acceptable
    
    Rationale: Allowing all users to view the top level of all networked user's home folder may not be desirable since it may lead to the revelation of sensitive information.
  "
  impact 1.0
  describe command("find /Users -regex .\\*/\\^.\\*\\$ -perm -00700 \\! -perm -00077 -xdev") do
    its("stdout") { should_not be_empty }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.1.2_Check_System_Wide_Applications_for_appropriate_permissions" do
  title "Check System Wide Applications for appropriate permissions"
  desc  "
    Applications in the System Applications Directory (/Applications) should be world executable since that is their reason to be on the system. They should not be world writable and allow any process or user to alter them for other processes or users to then execute modified versions
    
    Rationale: Unauthorized modifications of applications could lead to the execution of malicious code.
  "
  impact 1.0
  describe command("find /Applications -regex .\\*/.\\+\\\\.app -type f -perm -00755 \\! -perm -00022 -xdev") do
    its("stdout") { should_not be_empty }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.1.3_Check_System_folder_for_world_writable_files" do
  title "Check System folder for world writable files"
  desc  "
    Software sometimes insists on being installed in the /System Directory and have inappropriate world writable permissions.
    
    Rationale: Folders in /System should not be world writable. The audit check excludes the \"Drop Box\" folder that is part of Apple's default user template.
  "
  impact 1.0
  describe command("find /System -regex .\\*/\\!\\(Public/Drop\\ Box\\) -type f -perm -00711 \\! -perm -00022 -xdev") do
    its("stdout") { should_not be_empty }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.2.1_Configure_account_lockout_threshold" do
  title "Configure account lockout threshold"
  desc  "
    The account lockout threshold specifies the amount of times a user can enter an incorrect password before a lockout will occur.
    
    Ensure that a lockout threshold is part of the password policy on the computer
    
    Rationale: The account lockout feature mitigates brute-force password attacks on the system.
  "
  impact 1.0
end

control "xccdf_org.cisecurity.benchmarks_rule_5.2.2_Set_a_minimum_password_length" do
  title "Set a minimum password length"
  desc  "
    A minimum password length is the fewest number of characters a password can contain to meet a system's requirements.
    
    Ensure that a minimum of a 15 character password is part of the password policy on the computer.
    
    Where the confidentiality of encrypted information in FileVault is more of a concern requiring a longer password or passphrase may be sufficient rather than imposing additional complexity requirements that may be self-defeating.
    
    Rationale: Information systems that are not protected with strong password schemes including passwords of minimum length provide a greater opportunity for attackers to crack the password and gain access to the system.
  "
  impact 1.0
end

control "xccdf_org.cisecurity.benchmarks_rule_5.2.7_Password_Age" do
  title "Password Age"
  desc  "
    Over time passwords can be captured by third parties through mistakes, phishing attacks, third party breaches or merely brute force attacks. To reduce the risk of exposure and to decrease the incentives of password reuse (passwords that are not forced to be changed periodically generally are not ever changed) users should reset passwords periodically.
    This control uses 365 days as the acceptable value, some organizations may be more or less restrictive. This control mainly exists to mitigate against password reuse of the macOS account password in other realms that may be more prone to compromise. Attackers take advantage of exposed information to attack other accounts.
    
    Rationale: Passwords should be changed periodically to reduce exposure
  "
  impact 1.0
end

control "xccdf_org.cisecurity.benchmarks_rule_5.2.8_Password_History" do
  title "Password History"
  desc  "
    Over time passwords can be captured by third parties through mistakes, phishing attacks, third party breaches or merely brute force attacks. To reduce the risk of exposure and to decrease the incentives of password reuse (passwords that are not forced to be changed periodically generally are not ever changed) users must reset passwords periodically. This control ensures that previous passwords are not reused immediately by keeping a history of previous passwords hashes. Ensure that password history checks are part of the password policy on the computer. This control checks whether a new password is different than the previous 15.
    The latest NIST guidance based on exploit research referenced in this section details how one of the greatest risks is password exposure rather than password cracking. Passwords should be changed to a new unique value whenever a password might have been exposed to anyone other than the account holder. Attackers have maintained persistent control based on predictable password change patterns and substantially different patterns should be used in case of a leak.
    
    Rationale: Old passwords should not be reused
  "
  impact 1.0
end

control "xccdf_org.cisecurity.benchmarks_rule_5.3_Reduce_the_sudo_timeout_period" do
  title "Reduce the sudo timeout period"
  desc  "
    The sudo command allows the user to run programs as the root user. Working as the root user allows the user an extremely high level of configurability within the system.
    
    Rationale: The sudo command stays logged in as the root user for five minutes before timing out and re-requesting a password. This five minute window should be eliminated since it leaves the system extremely vulnerable. This is especially true if an exploit were to gain access to the system, since they would be able to make changes as a root user.
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Reduce the sudo timeout period\n# \n\noutput=$(\nsudo cat /etc/sudoers | grep timestamp \n)\n\n# If results returns pass, otherwise fail.\nif [ \"$output\" == \"Defaults timestamp_timeout=0\" ] ; then\n\techo \"$output\"\n    exit 0\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 1\nfi\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.4_Use_a_separate_timestamp_for_each_usertty_combo" do
  title "Use a separate timestamp for each user/tty combo"
  desc  "
    In combination with removing the sudo timeout grace period a further mitigation should be in place to reduce the possibility of a a background process using elevated rights when a user elevates to root in an explicit context or tty. With the included sudo 1.8 introduced in 10.12 the default value is to have tty tickets for each interface so that root access is limited to a specific terminal. The default configuration can be overwritten or not configured correctly on earlier versions of macOS.
    
    Rationale: Additional mitigation should be in place to reduce the risk of privilege escalation of background processes.
  "
  impact 1.0
  describe file("/etc/sudoers") do
    its("content") { should_not match(/Defaults !tty_tickets/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.7_Do_not_enable_the_root_account" do
  title "Do not enable the \"root\" account"
  desc  "
    The root account is a superuser account that has access privileges to perform any actions and read/write to any file on the computer. With some Linux distros the system administrator may commonly uses the root account to perform administrative functions.
    
    Rationale: Enabling and using the root account puts the system at risk since any successful exploit or mistake while the root account is in use could have unlimited access privileges within the system. Using the sudo command allows users to perform functions as a root user while limiting and password protecting the access privileges. By default the root account is not enabled on a macOS computer. An administrator can escalate privileges using the sudo command (use -s or -i to get a root shell).
  "
  impact 1.0
  describe bash("#!/usr/bin/env sh\n\n#\n# CIS-CAT Script Check Engine\n# \n# Name                Date       Description\n# -------------------------------------------------------------------\n# Sara Lynn Archacki  04/02/19   Do not enable the \"root\" account\n# \n\noutput=$(\ndscl . -read /Users/root AuthenticationAuthority 2>&1\n)\n\n# If result returns it should pass, otherwise fail.\nif [ \"$output\" == \"No such key: AuthenticationAuthority\" ] ; then\n\techo \"$output\"\n    exit 0\nelse\n    # print the reason why we are failing\n    echo \"$output\"\n    exit 1\nfi\n") do
    its("exit_status") { should eq 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.8_Disable_automatic_login" do
  title "Disable automatic login"
  desc  "
    The automatic login feature saves a user's system access credentials and bypasses the login screen, instead the system automatically loads to the user's desktop screen.
    
    Rationale: Disabling automatic login decreases the likelihood of an unauthorized person gaining access to a system.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.loginwindow', xpath: '/plist/dict/key[text()=\'autoLoginUser\']') do
    it { should exist }
    its("xpath_value") { should cmp "" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.9_Require_a_password_to_wake_the_computer_from_sleep_or_screen_saver" do
  title "Require a password to wake the computer from sleep or screen saver"
  desc  "
    Sleep and screensaver modes are low power modes that reduces electrical consumption while the system is not in use.
    
    Rationale: Prompting for a password when waking from sleep or screensaver mode mitigates the threat of an unauthorized person gaining access to a system in the user's absence.
  "
  impact 1.0
  describe plist('$HOME/Library/Preferences/com.apple.screensaver.plist', xpath: 'name(/plist/dict/key[text()=\'askForPassword\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.11_Require_an_administrator_password_to_access_system-wide_preferences" do
  title "Require an administrator password to access system-wide preferences"
  desc  "
    System Preferences controls system and user settings on a macOS Computer. System Preferences allows the user to tailor their experience on the computer as well as allowing the System Administrator to configure global security settings. Some of the settings should only be altered by the person responsible for the computer.
    
    Rationale: By requiring a password to unlock System-wide System Preferences the risk is mitigated of a user changing configurations that affect the entire system and requires an admin user to re-authenticate to make changes
  "
  impact 1.0
  describe command('security authorizationdb read system.preferences | xpath "/plist/dict/key[text()=\'shared\']/following-sibling::*[1]"') do
    its("stdout") { should include "false" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.12_Disable_ability_to_login_to_another_users_active_and_locked_session" do
  title "Disable ability to login to another user's active and locked session"
  desc  "
    macOS has a privilege that can be granted to any user that will allow that user to unlock active user's sessions.
    
    Rationale: Disabling the admins and/or user's ability to log into another user's active and locked session prevents unauthorized persons from viewing potentially sensitive and/or personal information.
  "
  impact 1.0
  describe command('security authorizationdb read system.login.screensaver | xpath "/plist/dict/array/child::*[1]"') do
    its("stdout") { should include "use-login-window-ui" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.13_Create_a_custom_message_for_the_Login_Screen" do
  title "Create a custom message for the Login Screen"
  desc  "
    An access warning informs the user that the system is reserved for authorized use only, and that the use of the system may be monitored.
    
    Rationale: An access warning may reduce a casual attacker's tendency to target the system. Access warnings may also aid in the prosecution of an attacker by evincing the attacker's knowledge of the system's private status, acceptable use policy, and authorization requirements.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.loginwindow.plist', xpath: '/plist/dict/key[text()=\'LoginwindowText\']/following-sibling::*[1]') do
    it { should exist }
    its("xpath_value") { should match(/^.+$/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.15_Do_not_enter_a_password-related_hint" do
  title "Do not enter a password-related hint"
  desc  "
    Password hints help the user recall their passwords for various systems and/or accounts. In most cases, password hints are simple and closely related to the user's password.
    
    Rationale: Password hints that are closely related to the user's password are a security vulnerability, especially in the social media age. Unauthorized users are more likely to guess a user's password if there is a password hint. The password hint is very susceptible to social engineering attacks and information exposure on social media networks
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_5.19_System_Integrity_Protection_status" do
  title "System Integrity Protection status"
  desc  "
    System Integrity Protection is a security feature introduced in OS X 10.11 El Capitan. System Integrity Protection restricts access to System domain locations and restricts runtime attachment to system processes. Any attempt to attempt to inspect or attach to a system process will fail. Kernel Extensions are now restricted to /Library/Extensions and are required to be signed with a Developer ID.
    
    Rationale: Running without System Integrity Protection on a production system runs the risk of the modification of system binaries or code injection of system processes that would otherwise be protected by SIP.
  "
  impact 1.0
  describe command('system_profiler SPSoftwareDataType -xml | xpath "/plist/array/dict/array/dict/key[.=\'system_integrity\']/following-sibling::*[1]"') do
    its("exit_status") { should cmp 0 }
    its("stdout") { should match(/<string>integrity_enabled<\/string>/) }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_6.1.1_Display_login_window_as_name_and_password" do
  title "Display login window as name and password"
  desc  "
    The login window prompts a user for his/her credentials, verifies their authorization level and then allows or denies the user access to the system.
    
    Rationale: Prompting the user to enter both their username and password makes it twice as hard for unauthorized users to gain access to the system since they must discover two attributes.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.loginwindow.plist', xpath: 'name(/plist/dict/key[text()=\'SHOWFULLNAME\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_6.1.2_Disable_Show_password_hints" do
  title "Disable \"Show password hints\""
  desc  "
    Password hints are user created text displayed when an incorrect password is used for an account.
    
    Rationale: Password hints make it easier for unauthorized persons to gain access to systems by providing information to anyone that the user provided to assist remembering the password. This info could include the password itself or other information that might be readily discerned with basic knowledge of the end user.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.loginwindow.plist', xpath: '/plist/dict/key[text()=\'RetriesUntilHint\']/following-sibling::*[1]') do
    it { should exist }
    its("xpath_value") { should cmp 0 }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_6.1.3_Disable_guest_account_login" do
  title "Disable guest account login"
  desc  "
    The guest account allows users access to the system without having to create an account or password. Guest users are unable to make setting changes, cannot remotely login to the system and all created files, caches, and passwords are deleted upon logging out.
    
    Rationale: Disabling the guest account mitigates the risk of an untrusted user doing basic reconnaissance and possibly using privilege escalation attacks to take control of the system.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.loginwindow.plist', xpath: 'name(/plist/dict/key[text()=\'GuestEnabled\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "false" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_6.1.4_Disable_Allow_guests_to_connect_to_shared_folders" do
  title "Disable \"Allow guests to connect to shared folders\""
  desc  "
    Allowing guests to connect to shared folders enables users to access selected shared folders and their contents from different computers on a network.
    
    Rationale: Not allowing guests to connect to shared folders mitigates the risk of an untrusted user doing basic reconnaissance and possibly use privilege escalation attacks to take control of the system.
  "
  impact 1.0
  describe plist('/Library/Preferences/com.apple.AppleFileServer.plist', xpath: 'name(/plist/dict/key[text()=\'guestAccess\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "false" }
  end
  describe plist('/Library/Preferences/SystemConfiguration/com.apple.smb.server.plist', xpath: 'name(/plist/dict/key[text()=\'AllowGuestAccess\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "false" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_6.1.5_Remove_Guest_home_folder" do
  title "Remove Guest home folder"
  desc  "
    In the previous two controls the guest account login has been disabled and sharing to guests has been disabled as well. There is no need for the legacy Guest home folder to remain in the file system. When normal user accounts are removed you have the option to archive it, leave it in place or delete. In the case of the guest folder the folder remains in place without a GUI option to remove it. If at some point in the future a Guest account is needed it will be re-created. The presence of the Guest home folder can cause automated audits to fail when looking for compliant settings within all User folders as well. Rather than ignoring the folders continued existence it is best removed.
    
    Rationale: The Guest home folders are unneeded after the Guest account is disabled and could be used inappropriately.
  "
  impact 1.0
  describe file("/Users/Guest") do
    it { should_not exist }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_6.3_Turn_on_filename_extensions" do
  title "Turn on filename extensions"
  desc  "
    A filename extension is a suffix added to a base filename that indicates the base filename's file format.
    
    Rationale: Visible filename extensions allows the user to identify the file type and the application it is associated with which leads to quick identification of misrepresented malicious files.
  "
  impact 1.0
  describe plist('$HOME/Library/Preferences/.GlobalPreferences.plist', xpath: 'name(/plist/dict/key[text()=\'AppleShowAllExtensions\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "true" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_6.4_Disable_the_automatic_run_of_safe_files_in_Safari" do
  title "Disable the automatic run of safe files in Safari"
  desc  "
    Safari will automatically run or execute what it considers safe files. This can include installers and other files that execute on the operating system. Safari bases file safety by using a list of filetypes maintained by Apple. The list of files include text, image, video and archive formats that would be run in the context of the OS rather than the browser.
    
    Rationale: Hackers have taken advantage of this setting via drive-by attacks. These attacks occur when a user visits a legitimate website that has been corrupted. The user unknowingly downloads a malicious file either by closing an infected pop-up or hovering over a malicious banner. An attacker can create a malicious file that will fall within Safari's safe file list that will download and execute without user input.
  "
  impact 1.0
  describe plist('$HOME/Library/Preferences/com.apple.Safari.plist', xpath: 'name(/plist/dict/key[text()=\'AutoOpenSafeDownloads\']/following-sibling::*[1])') do
    it { should exist }
    its("xpath_value") { should cmp "false" }
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_7.6_Automatic_Actions_for_Optical_Media" do
  title "Automatic Actions for Optical Media"
  desc  "Managing automatic actions, while useful in very few situations, is unlikely to increase security on the computer and does complicate the users experience and add additional complexity to the configuration. These settings are user controlled and can be changed without Administrator privileges unless controlled through MCX settings or Parental Controls. Unlike Windows Auto-run the optical media is accessed through Operating System applications, those same applications can open and access the media directly. If optical media is not allowed in the environment the optical media drive should be disabled in hardware and software"
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_7.10_Repairing_permissions_is_no_longer_needed" do
  title "Repairing permissions is no longer needed"
  desc  "
    With the introduction of System Integrity Protection (SIP) Apple has removed the necessity of repairing permissions. In earlier versions of the Operating System repair permissions checked the receipt files of installed software and ensured that the existing permissions in the file system matched what the receipts said it should. System integrity protection manages and blocks permission to certain directories continuously.
    
    [http://www.macissues.com/2015/10/02/about-os-x-10-11-el-capitan-and-permissions-fixes/](http://www.macissues.com/2015/10/02/about-os-x-10-11-el-capitan-and-permissions-fixes/)
    
    [https://en.wikipedia.org/wiki/System_Integrity_Protection](https://en.wikipedia.org/wiki/System_Integrity_Protection)
    
    [http://www.infoworld.com/article/2988096/mac-os-x/sorry-unix-fans-os-x-el-capitan-kills-root.html](http://www.infoworld.com/article/2988096/mac-os-x/sorry-unix-fans-os-x-el-capitan-kills-root.html)
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_7.12_Siri_on_macOS" do
  title "Siri on macOS"
  desc  "
    With macOS 10.12 Sierra Apple has introduced Siri from iOS to macOS. While there are data spillage concerns with use of software data gathering personal assistants the risk here does not seem greater in sending queries to Apple through Siri than in sending search terms in a browser to Google or Microsoft. While it is possible that Siri will be used for local actions rather than Internet searches which could, in theory, tell Apple about confidential Programs and Projects that should not be revealed this appears be an edge use case.
    
    In cases where sensitive and protected data is processed and Siri could help a user navigate their machine and expose that information it should be disabled. Siri does need to phone home to Apple so it should not be available from air-gapped networks as part of it's requirements.
    
    Most of the use case data published has shown that Siri is a tremendous time saver on iOS where multiple screens and menus need to be navigated through. Information like sports scores, weather, movie times and simple to-do items on existing calendars can be easily found with Siri. None of the standard use cases should be more risky than already approved activity. Where \"normal\" user activity is already limited Siri use should be controlled as well.
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_7.13_Apple_Watch_features_with_macOS" do
  title "Apple Watch features with macOS"
  desc  "
    With the release of macOS 10.12 Apple introduced a feature where the owner of an Apple Watch can lock and unlock their screen simply by being within range of a 10.12 computer when both devices are using the same AppleID with iCloud active. The benefit of not leaving the computer unlocked while the user is out of sight and readying the computer to resume work when the user returns without having to type in a password or insert a smartcard does seem attractive to people who have the Apple Watch. It is a continuation of other features like hand-off and continuity for the multiple Apple products users who have grown to expect their devices to work together.
    
    For the screen unlock capability in particular it may not be attractive to organizations that are managing Apple devices and credentials. The capability allows a user to unlock their computer tied to an Enterprise account with a personal token that is not managed or controlled by the Enterprise. If the user loses their watch revoking the credential that can unlock the screen might be problematic.
    
    Unless Enterprise control of the watch as a token tied to a user identity can be achieved Apple Watches should not be used for screen unlocks. The risk of an auto-lock based on the user being out of proximity may still be acceptable if possible to do lock only.
    
    This functionality does require the computer to be logged in to iCloud. If iCloud is disabled the Apple watch lock and unlock will not be possible.
    
    A profile may be used to control unlock functionality.
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_7.15_Unified_logging" do
  title "Unified logging"
  desc  "
    Starting with macOS 10.12 Apple introduced unified logging. This capability replaces the previous logging methodology with centralized system wide common controls. A full explanation of macOS logging behavior is beyond the scope of this Benchmark. These changes impact previous logging controls from macOS Benchmarks. At this point many of the syslog controls have been or are being removed since the old logging methods have been deprecated. Controls that still appear useful will be retained. Some legacy controls have been removed for this release.
    
    More info
    https://developer.apple.com/documentation/os/logging
    https://eclecticlight.co/2018/03/19/macos-unified-log-1-why-what-and-how/
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end

control "xccdf_org.cisecurity.benchmarks_rule_7.16_AirDrop_security_considerations" do
  title "AirDrop security considerations"
  desc  "
    AirDrop is Apple's built-in on demand ad hoc file exchange system that is compatible with both macOS and iOS. It uses Bluetooth LE for discovery that limits connectivity to Mac or iOS users that are in close proximity. Depending on the setting it allows everyone or only Contacts to share files when they are nearby to each other.
    
    In many ways this technology is far superior to the alternatives. The file transfer is done over a TLS encrypted session, does not require any open ports that are required for file sharing, does not leave file copies on email servers or within cloud storage, and allows for the service to be mitigated so that only people already trusted and added to contacts can interact with you.
    
    Even with all of these positives some environments may wish to disable AirDrop. Organizations where Bluetooth and Wireless are not used will disable AirDrop by blocking it's necessary interfaces. Organizations that have disabled USB and other pluggable storage mechanisms and have blocked all unmanaged cloud and transfer solutions for DLP may want to disable AirDrop as well.
    
    AirDrop should be used with Contacts only to limit attacks.
    
    More info
    https://www.imore.com/how-apple-keeps-your-airdrop-files-private-and-secure
    https://en.wikipedia.org/wiki/AirDrop
  "
  impact 0.0
  describe "No tests defined for this control" do
    skip "No tests defined for this control"
  end
end