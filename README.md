# Vagrant::Ohai

This is a [vagrant](http://vagrantup.com) plugin which installs an Ohai plugin providing network information to Chef.
In particular, the ipaddress is set to the private network defined in vagrant, if one is present.

## Installation

    vagrant plugin install vagrant-ohai

## Usage

The plugin will automatically activate when using the `:chef_solo`, `:chef_zero`, `:chef_apply`, `:chef_client` or `:shell` provisioners. If you want to disable it, put `config.ohai.enable = false` in your Vagrantfile.
If you wish to use a primary nic which is not a private network, e.g. when using a bridge, set the `primary_nic` option:

    config.ohai.primary_nic = "eth1"

To activate custom plugin support put `config.ohai.plugins_dir = <full_path_to_plugins_dir>` in your Vagrantfile

    config.ohai.plugins_dir = "/var/ohai/custom_plugins"

## Compatibility

This plugin works with Vagrant 1.2.3 and above.

It has only been tested on VirtualBox but should also work with other Vagrant providers.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
