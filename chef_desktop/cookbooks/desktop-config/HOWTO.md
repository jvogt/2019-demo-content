# Welcome to the Chef Desktop

Chef Desktop is a pre-defined set of Chef Infra resources to help you manage your desktop environment. The desktop services target the following basic functions:

- Hard drive Encryption
- Screensaver with a password
- Password policy to set complexity et al
- Create a rescue account or additional user accounts
- Application management to deploy and manage apps that you care about
- Update management to control where/when how OS and related patches are installed
- Desktop control to limit access to features or services

## Target Audience

The target audience for this Desktop Administrators who may have limited command-line or tools experience. Our goal is to create a work pattern that leads you to exploring the Chef Infra Client from the command line on your own. This cookbook should guide you from starting from scratch to success in a few hours, perhaps 1 day

[TOC]

### Tools You Will Need

WinSCP - You need it to transfer files to and from the Chef Infra Server

[Download]: https://winscp.net/eng/download.php

Visual Studio Code

[Download]: https://code.visualstudio.com/download

Visual Studio Code Plugins:

- Chef Infra Extension
- Python
- PowerShell
- YAML

Macinbox

[Download]: https://github.com/bacongravy/macinbox

VirtualBox

[Download]: https://www.virtualbox.org/wiki/Downloads

VirtualBox Extensions

[Download]: https://www.virtualbox.org/wiki/Downloads

Vagrant

[Download]: https://www.vagrantup.com/downloads.html

## Configuration Overview

There is a work triangle in play here - The first leg is the Chef Infra Server with Automate that holds and applies configurations to your nodes. The second leg is a Developer node running Chef Workstation from which you create and define the policies and settings that the Chef Infra Server metes out. The third leg of the triangle is the list of nodes to which the various polices and settings are applied. Your developer node will be one of these.

## Setup Automate on Chef Infra Server

[Setup]: https://automate.chef.io/docs/infra-server/	"Installing Chef Infra and Automate"

## Download your keys and knife config from your Chef Infra Server

Run the following commands from any folder on your Chef Infra Server.

```powershell
$ chef-server-ctl user-create ... # make user
```

```powershell
$ chef-server-ctl org-create... # make org
```

Copy the keys (pem files) and the knife config file to your system. You'll probably need SCP/WinSCP to do that. They will be located in the root of whatever folder you were in when you ran those commands.

## Download and install Chef Workstation

[Download]: https://downloads.chef.io/chef-workstation

Download Chef Workstation and run the installer on the Developer workstation. Accept the defaults and let it do its work.

## Create your local repo

Now, back on your local machine, we need to create a local repository to put your cookbooks and related chef work in. Run this from the command line of your root folder (c:\ or ~/)

```powershell
$ chef generate repo my_repo
$ chef generate cookbook my_repo/cookbooks/my_cookbook

$ chef generate repo c:\my_repo
$ chef generate cookbook c:\my_repo\cookbooks\my_cookbook
```

Add your keys and configuration file to your repo in a .chef folder. The folder won't exist by default. Please create it from the command line. Note the leading period. To make those settings globally available to you, create that .chef folder underneath your "home" folder instead.

```powershell
$ c:\users\<you>\.chef # Windows
$ ~/Users/<you>/.chef # macOS
```

#### What ARE all these files and directories?

Take a look through the all the files and directories to familiarize yourself with them. Notice that the root of each cookbook directory has approximately the same sets of files.

## Create your first cookbook in your repo

​```bash
$ cd c:\my_repo\cookbooks
$ chef generate cookbook my_cookbook
```

## Add content to your new Cookbook

Open your repo in Visual Studio Code. The one key file you'll want to manage is the metadata.rb file. Please take a moment now to add your contact information and pick a starting version number for your cookbook.

Mac users might need to download PowerShell 7 first. You can do that with brew. Read more [here](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7). It takes about 5 minutes to install

Navigate to the my_cookbook directory and open the default.rb in the \recipes folder. Add the following code. Be mindful of spacing. Also ensure you are setup for LF line spacing and not CRLF (bottom right of the status bar in Visual Studio Code)

```ruby
powershell_script 'get my path' do
 code <<-CODE
   [Environment]::GetEnvironmentVariable("Path")
 CODE
end
```

## Test your cookbook against your local system

Navigate to your cookbook directory. That should be something like c:\my_repo\cookbooks\my_cookbook. Then run the following command to test your code out.

```powershell
$ chef-client -z -o my_cookbook
```

The output from that 'run' should have displayed the Path to you. If it didn't or you got an error, go back and check your spelling and spacing.

### Install the Chef Desktop cookbook into your repo

Copy the desktop-config cookbook you received from Chef and unzip that file into your cookbooks directory. Now you have 2 cookbooks.

Please update the metadata.rb file for the chef cookbook to add your contact details.

### Configure Chef Desktop

Chef Desktop comes with a large number of options for configuring your Windows and Mac desktops. Look through the mac.rb and windows.rb files to explore what settings you want to turn on for your testing and evaluation. For those resources you don't want to explore yet, set their action to ':nothing' (without the quotes)

### Now Test it Against Your System

#### 1 - Setup Test-Kitchen

We don't want to run this against a live desktop or laptop yet while we're testing. So we'll use a chef tool called Test-Kitchen. In the root of your Chef Desktop cookbook you'll find a kitchen.yml file. Open that in VSCode and adjust it to look like this:

We're going to build out 2 distinct images to test our code against. One will be for OS X and the other for Windows.

To build your Mac image you must be using version 10.15.x. Go to the App store and download a copy of OS X. You'll have to run these commands on your Mac to get the basic image (refer to Apple licensing [here](https://www.apple.com/legal/sla/docs/macOSCatalina.pdf))

Run macinbox on your Mac device with these switches:

```powershell
$ sudo macinbox -n my_mac_image -c 2 -m 4096 --no-gui --box-format virtualbox
```

That will take about 15 minutes to correctly build the image for you.

Now lets go build a Windows box. On either the same mac or a Windows device, run the following commands to build out a Windows 10 image.

```powershell
$ git clone https://github.com/chef/bento
$ cd .\bento\packer_templates\windows\
$ packer build -only=virtualbox-iso .\windows-10.json
```

That will need a few minutes to build out as well. Once that is completed we need to pull both boxes into Virtualbox so Test-Kitchen can use them for test mules.

```powershell
$ vagrant box add windows-10-virtualbox.box --name win10box
$ vagrant box add my_mac_image
```

Finally, we need to configure the kitchen.yml file. This file pulls together the images we just created above and provisions them for use for testing our cookbooks against. Notice that we're configuring both the Windows and Mac images at the same time on the same system. You should be using Chef Infra Client 16.x.x for testing with.

```yaml
---
provisioner:
  name: chef_zero
  deprecations_as_errors: true
  chef_license: accept-no-persist
  product_name: chef
  channel: stable

verifier:
  load_plugins: true
  name: inspec

platforms:
  - name: macos
    driver:
      box: my_mac_image
      name: vagrant
      customize:
        memory: 4096
        cpus: 2

  - name: windows
    driver:
      box: win10box
      name: vagrant
      customize:
        memory: 4096
        cpus: 2

suites:
  - name: default
    provisioner:
      policyfile: policyfile.rb
    verifier:
      inspec_tests:
        - path: test/integration/default
```

#### 2 - Create the Running Images

You downloaded the 2 testing images. Now issue the following command to get them started:

```powershell
$ kitchen create
```

#### 3 - Apply the Cookbooks to the Images

Now run the following command to 'converge' the cookbooks with the base OS image

```powershell
$ kitchen converge
```

#### 4 - Verify the settings

Now that we have applied the cookbook to our test nodes, we need to verify that. Back in VSCode, navigate under your Chef Desktop folder to test\integration\default and notice that there are a number of pre-built integration tests for you. Carefully go through these and adjust them to match the settings you chose in your mac.rb and windows.rb files. Now run this:

```powershell
$ kitchen verify
```

If any of the tests fail, check the out and compare your settings in the mac.rb or windows.rb files against what the matching test files say.


#### Alternately

In the future when you get more comfortable, you can run Kitchen Test to perform all of the above steps at once. It also includes the command below for cleanup.

```powershell
$ kitchen test
```

#### Cleanup

When you are finished with your testing you can run the following command to delete the running test images

```powershell
$ kitchen destroy
```

### Push Chef Desktop to your Chef Infra Server

From the command line navigate to your /cookbooks folder and type in the following command. <u>One thing to note here is that the name that knife and other Chef tools are looking for is the one specified inside of either the metadata.rb file or the policyfile.rb. If that name is capitalized, you will need to capitalize the name with your knife or chef commands.</u>

```powershell
$ knife cookbook upload <your cookbook name>
```

Now your Chef Infra Server has the cookbook and settings to push out to your nodes.

## Configure the Policyfile for Chef Infra Server

The next thing to do is to check our policy file and apply it to our test nodes. We use policies as a way to more conveniently manage the nodes.

First, verify that your Policyfile.rb looks similar to the following

```ruby
# frozen_string_literal: true

name 'desktop-config'

# default_source :supermarket, 'https://supermarket.chef.io' do |s|
#   s.preferred_for 'chef-client'
# end

# run_list: chef-client will run these recipes in the order specified.
run_list 'desktop-config::default'

# Specify a custom source for a single cookbook:
cookbook 'desktop-config', path: '.'
```

Now we need to get our Policy file uploaded to the Chef Infra Server. Call chef update to do some needed housekeeping around your policy file. You'll need to run that command every time you update the version of your cookbook. Please note the single-quotes. They must be used.

```powershell
$ chef update
$ chef push 'my_policy_group' 'my_policyfile'
```

## Bootstrapping the first Node

Now we've come to the exciting part. Trying this out on our first node. First we need to make a client.rb file that will contain the basic information needed to connect to the chef server instance. The first thing to do is identify a 'test node' - a virtual machine or laptop/desktop we can run our working cookbook against.

On the test node, get the serial number of that device and come back to your workstation node

<u>On Your Workstation</u>

Now back on your workstation, we're going configure the server and the client.rb file for your node.

Issue the following commands to register your node with the Chef Infra Server and apply the new policy to it.

```powershell
# knife node policy set <serial number of a test node> '<name you want to use to group nodes with>' '<the name of the policy file as noted in the name section above>'

$ knife node create S90T7HK2
Created node [S90T7HK2]
$ knife node policy set S90T7HK2 'Windows_Node_Policy_Group' 'desktop-config'
Successfully set the policy on node S90T7HK2
```

Now create a file locally called client.rb and it should resemble the example below, Obviously you'll need to replace the names with the correct ones for your settings. The value of the node name should be replaced with the serial number of your test node.

```ruby
log_level              :info
log_location           STDOUT
validation_client_name 'my_org-validator'
validation_key         File.expand_path('c:\chef\my_org-validator.pem')
chef_server_url        "https://my.fqdn.com/mychefserverinstance"
ssl_verify_mode        :verify_peer
local_key_generation   true
rest_timeout           30
http_retry_count       3
chef_license           'accept'
node_name              'S90T7HK2'
```

<u>On Your Test Node</u>

 Go to your test node and install the chef client from an elevated PowerShell window or use sudo if you're on a mac. The mac command line script is illustrated [here](https://docs.chef.io/chef_install_script/)

```powershell
$ . { iwr -useb https://omnitruck.chef.io/install.ps1 } | iex; install -channel current  -project chef
```

Once that has finished installing, copy the client.rb file with the correct data for your node and Chef Infra Server in it and place that in c:\chef. Then copy the validator.pem file you downloaded from your Chef Infra Server at the beginning of the exercise and put it in the same folder. Now run this:

```powershell
$ Chef-client
```

If all goes according to plan, then the desktop-config cookbook should deploy to your test node.

## What's Next?

The next step of course is to automate a number of these processes because no one has time to manually bootstrap a 1,000 nodes.
