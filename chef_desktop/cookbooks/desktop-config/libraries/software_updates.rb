module Chefdesktop
  module SoftwareUpdates
    NO_NEW_SOFTWARE = Regexp.escape('No new software available.')
    SOFTWARE_UPDATE_COMMAND = '/usr/sbin/softwareupdate'.freeze

    def updates_available?
      available_updates_command = shell_out(SOFTWARE_UPDATE_COMMAND, '--list', '--all')
      available_updates_command.stderr.chomp.match?(no_new_software_pattern)
    end

    def automatic_check_disabled?
      schedule_check_command = shell_out(SOFTWARE_UPDATE_COMMAND, '--schedule')
      schedule_check_command.stdout.chomp == 'Automatic check is off'
    end
  end
end

Chef::Recipe.include(Chefdesktop::SoftwareUpdates)
Chef::Resource.include(Chefdesktop::SoftwareUpdates)
