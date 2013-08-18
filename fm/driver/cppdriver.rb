
require 'fm/base'
require 'erb'
module FM
  module Driver
    class CppDriver < DriverBase
      def dump_all
        @reserved = [:int,:long,:double]
        ERB.new(::FM::Heredoc::Cpp::Class_template).result(binding)
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
  end
  
  module Heredoc
    module Cpp
Class_template=<<CPP_CLASS_END
<%for dep in @info[:deps]%>
<%unless @reserved.include? dep.to_sym %>#include <<%=dep%>><%end%><%end%>

#include <<%=@info[:parent]%>.h><%for comp in @info[:comps]%>
<%unless @reserved.include? comp.to_sym %>#include <<%=comp%>.h><%end%><%end%>
class <%=@info[:self]%><%= (@info[:parent])? ":public " :" "%><%=@info[:parent]%>{
    <%for elem in @info[:comps]%>
    <%=elem%> _<%=elem.to_s.downcase%>;<%end%>
public:
    <%=@info[:self]%>();
<%for mtd in @info[:methods][:public]%>
    <%=dump_sign(mtd)%>;<%end%>

private:<%for mtd in @info[:methods][:private]%>
    <%=dump_sign(mtd)%>;<%end%>
};

CPP_CLASS_END
    end
  end
end