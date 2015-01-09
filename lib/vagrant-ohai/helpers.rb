module VagrantPlugins
  module Ohai
    #
    module Helpers
      def chef_provisioners
        @machine.config.vm.provisioners.find_all do |provisioner|
          [:shell, :chef_client, :chef_solo, :chef_zero, :chef_apply].include? provisioner.name
        end
      end
    end
  end
end
