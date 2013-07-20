module VagrantPlugins
  module Ohai
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :enable

      def initialize
        @enable = UNSET_VALUE
      end
      def finalize!
        @enable = true if @enable == UNSET_VALUE
      end

      def validate(machine)
        case @enable
        when TrueClass, FalseClass
          {}
        else
          {"enable" => ["enable must be true or false"] }
        end
      end

    end
  end
end
