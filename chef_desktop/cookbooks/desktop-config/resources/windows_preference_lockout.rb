# frozen_string_literal: true

provides :windows_preference_lockout
description 'A Resource to block users from using certain features - think locking out USB or touchscreen'

unified_mode true

# set usb and power button when power management set to max to create a kiosk mode
# test for and disable a touch screen as well
