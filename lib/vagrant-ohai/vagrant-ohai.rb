require "vagrant-ohai/version"
require "vagrant/plugin"

raise RuntimeException, "vagrant-ohai will only work with Vagrant 1.2.3 and above!" if Vagrant::VERSION <= "1.2.3"

module VagrantPlugins
  module Ohai 
    class Plugin < Vagrant.plugin("2")
      name "vagrant-ohai"
      description <<-DESC
      This plugin ensures ipaddress and cloud attributes in Chef
      correspond to Vagrant's private network
      DESC

      hook_block = proc do |hook|
        require_relative 'action_install_ohai_plugin'
        require_relative 'action_configure_chef'
        hook.after(Vagrant::Action::Builtin::Provision, ActionInstallOhaiPlugin)
        hook.before(Vagrant::Action::Builtin::ConfigValidate, ActionConfigureChef)
      end

      action_hook(:install_ohai_plugin, :machine_action_provision, &hook_block) 
      action_hook(:install_ohai_plugin, :machine_action_up, &hook_block) 

      config(:ohai) do
        require_relative "config"
        Config
      end
    end
  end
end
