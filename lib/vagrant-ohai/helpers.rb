module VagrantPlugins
  module Ohai
    module Helpers

      def chef_provisioners
        @machine.config.vm.provisioners.find_all {|provisioner|
            [:chef_client, :chef_solo].include? provisioner.name }
      end

    end
  end
end
