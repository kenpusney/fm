
require 'fm/base'
require 'fm/heredoc'
require 'erb'
module FM
  module Driver
    class CppDriver < FM::FMDriver
      def dump_all
        @reserved = [:int,:long,:double]
        ERB.new(::FM::Heredoc::Cpp_class_template).result(binding)
      end

      def dump_sign(elem)
        "#{elem[:return] ? elem[:return] : "void"} #{elem[:name]}(#{dump_args(elem[:args])})"
      end

      def dump_args(args)
        if args
          args.map {|elem|
            "#{elem[:type]} #{elem[:name]}"
          }.join(", ")
        else
          ""
        end
      end
    end

    class JavaDriver < CppDriver
      def dump_all
        @reserved = [:int,:long,:double]
        @info[:deps] = @info[:deps].map { |e|  e.gsub('/','.') }
        ERB.new(::FM::Heredoc::Java_class_template).result(binding)
      end
    end

    class RubyDriver < FM::FMDriver
      def dump_all
        @reserved = [:int,:long,:double]
        ERB.new(::FM::Heredoc::Ruby_class_template).result(binding)
      end

      def dump_sign(elem)
        "#{elem[:name]}#{dump_args(elem[:args])} -> #{elem[:return] ? elem[:return] : 'nil'}"
      end

      def dump_args(args)
        if args
          "(" + args.map {|elem|
            "#{elem[:name]}"
          }.join(", ") + ") # (" + 
          args.map {|elem|
            "#{elem[:type]}"
          }.join(", ") + ")"
        else
          " # nil"
        end
      end
    end
  end
end