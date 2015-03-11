require 'vagrant-ohai/helpers'

module VagrantPlugins
  module Ohai
    class ActionInstallOhaiPlugin
      OHAI_PLUGIN_PATH = File.expand_path("../../ohai/vagrant.rb", __FILE__)

      include VagrantPlugins::Ohai::Helpers

      def initialize(app, env)
        @app = app
        @env = env
        @machine = env[:machine]
      end

      def call(env)
        is_chef_used = chef_provisioners.any?
        @app.call(env)
        return unless @machine.communicate.ready?

        if is_chef_used && @machine.config.ohai.enable
          @machine.ui.info("Installing Ohai plugin")
          create_ohai_folders
          copy_ohai_plugin
        end
      end

      private

      def create_ohai_folders
        @machine.communicate.tap do |comm|
          comm.sudo("mkdir -p /etc/chef/ohai_plugins")
          comm.sudo("mkdir -p /etc/chef/ohai/hints")
          comm.sudo("chown -R #{@machine.ssh_info[:username]} /etc/chef/ohai_plugins")
          comm.sudo("chown -R #{@machine.ssh_info[:username]} /etc/chef/ohai/hints")
        end
      end

      def private_ipv4
        @private_ipv4 ||= @machine.config.vm.networks.find {|network| network.first == :private_network}[1][:ip]
      rescue
        nil
      end

      def vagrant_info
        info = {}
        info[:box] = @machine.config.vm.box
        info[:primary_nic] = @machine.config.ohai.primary_nic
        info[:private_ipv4] = private_ipv4
        info
      end

      def copy_ohai_plugin

        hint_file = Tempfile.new(["vagrant-ohai", ".json"])
        hint_file.write(vagrant_info.to_json)
        hint_file.close
        @machine.communicate.upload(hint_file.path, "/etc/chef/ohai/hints/vagrant.json")

        @machine.communicate.upload(OHAI_PLUGIN_PATH, "/etc/chef/ohai_plugins/vagrant.rb")
      end

    end
  end
end
