require 'rake'
require 'fileutils'
require 'yaml'
require 'erb'

COOKBOOK_NAME = 'desktop-config-lite'.freeze
RESOURCE_NAMES = %w(desktop_screensaver).freeze
RESOURCE_FILES = %w(mac_desktop_screensaver.rb windows_desktop_screensaver.rb).freeze
PLATFORMS = %w(windows mac).freeze

cookbook_root = File.join(File.dirname(__FILE__), '..')

def select_resources_from_readme
  in_resources_block = false
  in_resource = false
  resource_docs = [ ]

  File.read('README.md').each_line do |line|
    if line =~ /^## Resources/
      in_resources_block = true
    end

    next unless in_resources_block

    if line =~ /^## (?!Resources)/
      # no longer in the resources block
      in_resources_block = false
      next
    end

    if line =~ /^(### (?:\(.+\) )?\w+)/
      if line.match?(Regexp.union(RESOURCE_NAMES))
        resource_docs << line
        in_resource = true
      else
        in_resource = false
      end
      next
    end

    if in_resource
      resource_docs << line
    end
  end

  resource_docs
end

namespace :lite_cookbook do
  desc "Generates the public version of the cookbook for 'experimental' use"
  task :generate do
    Dir.chdir(cookbook_root)
    # Copy the desired current resources from the parent cookbook
    RESOURCE_FILES.each do |file|
      FileUtils.cp(File.join('resources', file), File.join(COOKBOOK_NAME, 'resources'))
    end

    # create yaml example recipes
    PLATFORMS.each do |p|
      yaml_recipe = YAML.load(File.read(File.join('recipes', "#{p}.yml")))
      resources = yaml_recipe['resources'].select { |r| RESOURCE_NAMES.include?(r['type']) }
      yaml_subset = { 'resources' => resources }
      File.write(File.join(COOKBOOK_NAME, 'recipes', "#{p}.yml"), yaml_subset.to_yaml)
    end

    # grab resource docs from README as the rake tasks isn't working right now
    eruby = Erubis::Eruby.new(File.read(File.join(COOKBOOK_NAME, 'README.md.erb')))
    readme_content = eruby.result(resources: select_resources_from_readme.join(''))
    File.write(File.join(COOKBOOK_NAME, 'README.md'), readme_content)
  end
end



