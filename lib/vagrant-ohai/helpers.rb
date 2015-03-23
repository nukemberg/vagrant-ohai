module VagrantPlugins
  module Ohai
    #
    module Helpers
      def chef_provisioners
        @machine.config.vm.provisioners.find_all do |provisioner|
          provisioner_name = provisioner.respond_to?('type') ? provisioner.type : provisioner.name
          [:shell, :chef_client, :chef_solo, :chef_zero, :chef_apply].include? provisioner_name
        end
      end
    end
  end
end
