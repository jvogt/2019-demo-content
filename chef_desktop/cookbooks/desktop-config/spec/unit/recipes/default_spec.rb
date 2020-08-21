#
# Cookbook:: desktop-config
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'desktop-config::default' do
  context 'with default attributes' do
    let(:node_attributes) do
      { platform: 'mac_os_x', version: '10.15' }
    end

    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(node_attributes)
      runner.converge(described_recipe)
    end

    xit 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end

describe 'desktop-config::mac' do
  context 'testing resources' do
    let(:node_attributes) do
      { platform: 'mac_os_x', version: '10.15' }
    end

    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(node_attributes, step_into: ['mac_updates'])
      runner.converge(described_recipe)
    end
  end
end

