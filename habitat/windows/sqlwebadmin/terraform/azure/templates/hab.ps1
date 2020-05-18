iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
New-NetFirewallRule -DisplayName \"Habitat TCP\" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 9631,9638
New-NetFirewallRule -DisplayName \"Habitat UDP\" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 9638
C:/ProgramData/chocolatey/choco install habitat -y --no-progress
C:/ProgramData/chocolatey/choco install powershell-core -y
hab pkg install core/windows-service
hab pkg exec core/windows-service install
mv -force c:\HabService.exe.config c:\hab\svc\windows-service\
start-service habitat
start-sleep -s 15

hab svc load ${package_name} --group ${release_channel} --channel ${release_channel} --strategy at-once #{bindings}
New-LocalUser habuser -Password (Convertto-securestring 'ch3fh@b1!' -asplaintext -force) -FullName 'Hab User' -Description 'Description of this account.'
