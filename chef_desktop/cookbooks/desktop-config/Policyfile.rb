# frozen_string_literal: true

name 'desktop-config'

# default_source :supermarket, 'https://supermarket.chef.io' do |s|
#   s.preferred_for 'chef-client'
# end

# run_list: chef-client will run these recipes in the order specified.
run_list 'desktop-config::default'

# Specify a custom source for a single cookbook:
cookbook 'desktop-config', path: '.'
