
module FM
  module Driver
    class DriverBase
      def initialize
        @info = nil
      end

      [:deps,:parent,:comps,:methods].each do |iattr|
        define_method("dump_#{iattr}".to_sym) { @info[iattr] }
      end

      def dump(info)
        @info = info
        dump_all
      end

      def dump_all
        "deps: " + dump_deps.to_s + 
        "\nparent: " + dump_parent.to_s +
        "\ncomps: " + dump_comps.to_s +
        "\nmethods: " + dump_methods.to_s
      end
    end
  end
end