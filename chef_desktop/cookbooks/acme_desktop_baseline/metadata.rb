name 'acme_desktop_baseline'
maintainer 'Chef Software Inc.'
maintainer_email 'humans@chef.io'
license 'Chef MLSA' # cookstyle: disable ChefSharing/InvalidLicenseString
description 'Acme Baseline Desktop Example'
version '0.1.0'
chef_version '>= 16.0'

issues_url 'https://getchef.zendesk.com/'
source_url 'https://github.com/chef/desktop-config'

supports 'mac_os_x'
supports 'windows'

depends 'desktop-config'
depends 'audit'