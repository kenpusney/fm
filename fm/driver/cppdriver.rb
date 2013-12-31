
require 'fm/class'
require 'erb'
module FM
  module Driver
    class CppDriver < DriverBase
      def dump_all
        @reserved = [:int,:long,:double,:string]
        ERB.new(::FM::Heredoc::Cpp::Class_template).result(binding)
      end

      def dump_sign(elem)
        "#{elem[:return] ? elem[:return] : "void"} #{elem[:name]}(#{dump_args(elem[:args])})"
      end

      def dump_alias(elem)
        "#{elem[:alias]}(#{dump_call_args(elem[:args])})"
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

      def dump_call_args(args)
        if args
          args.map {|elem|
            "#{elem[:name]}"
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
<%unless @reserved.include? comp[:type] %>#include <<%=comp[:type]%>.h><%end%><%end%>
class <%=@info[:self]%><%= (@info[:parent])? ":public " :" "%><%=@info[:parent]%>{
    <%for elem in @info[:comps]%>
    <%=elem[:type]%> <%=elem[:name]%>;<%end%>
public:
    <%=@info[:self]%>();
<%for comp in @info[:comps]
  if comp[:acl]
    for acl in comp[:acl].split ""
      prefix = case acl
          when 'r'
            comp[:type].to_s + ' get'+comp[:name]+"();"
          when 'w'
            'void set'+comp[:name]+"("+comp[:type].to_s+" value);"
          end
    %>
    <%=prefix%><%
    end
  end
end
%>
<%for mtd in @info[:methods][:public]%>
    <%=dump_sign(mtd)%>;<%end%>
<%for mtd in @info[:methods][:alias]%>
    <%=dump_sign(mtd) + ";  //@alias for "+ mtd[:alias] if mtd[:acl] == :public %><%end%>
<%for mtd in @info[:methods][:static]%>
    static <%=dump_sign(mtd)%>;<%end%>
<%for mtd in @info[:methods][:alias]%>
    <%=dump_sign(mtd) + ";  //@alias for "+ mtd[:alias] if mtd[:acl] == :public %><%end%>
private:<%for mtd in @info[:methods][:private]%>
    <%=dump_sign(mtd)%>;<%end%>
<%for mtd in @info[:methods][:alias]%>
    <%=dump_sign(mtd) + ";  //@alias for "+ mtd[:alias] if mtd[:acl] == :private %><%end%>
};

CPP_CLASS_END
    end
  end
end