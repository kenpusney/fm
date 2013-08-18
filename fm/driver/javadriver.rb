

require 'fm/driver/cppdriver'
module FM
  module Driver
    class JavaDriver < CppDriver
      def dump_all
        @reserved = [:int,:long,:double]
        @info[:deps] = @info[:deps].map { |e|  e.gsub('/','.') }
        ERB.new(::FM::Heredoc::Java::Class_template).result(binding)
      end
    end
  end

  module Heredoc
    module Java
Class_template=<<JAVA_CLASS_END
<%for dep in @info[:deps]%>
<%unless @reserved.include? dep.to_sym %>import <%=dep%>;<%end%><%end%>

public class <%=@info[:self]%><%= (@info[:parent])? " extends " : ""%><%=@info[:parent]%> {
    <%for elem in @info[:comps]%>
    private <%=elem[:type]%> <%=elem[:name]%>;<%end%>

    public <%=@info[:self]%>(){ }

    //* Getter & setter */<%for comp in @info[:comps]
  if comp[:acl]
    for acl in comp[:acl].split ""
      prefix = case acl
          when 'r'
            comp[:type].to_s + ' get'+comp[:name]+"(){ return "+comp[:name]+"; };"
          when 'w'
            'void set'+comp[:name]+"("+comp[:type].to_s+" value){ "+comp[:name]+"=value; };"
          end
    %>
    public <%=prefix%><%
    end
  end
end
%>
    
    //* Class methods */<%for mtd in @info[:methods][:static]%>
    public static <%=dump_sign(mtd)%> { 
        // Add your code here
    }<%end%>

    //* Instance methods/<%for mtd in @info[:methods][:public]%>
    public <%=dump_sign(mtd)%> {
        // add your code here
    }<%end%>
<%for mtd in @info[:methods][:private]%>
    private <%=dump_sign(mtd)%> { 
        // add your code here
    }<%end%>

    //* alias */<%for mtd in @info[:methods][:alias]%>
    <%=mtd[:acl]%> <%=dump_sign(mtd)%> { 
        return <%=dump_alias(mtd)%>; 
    }<%end%>
}

JAVA_CLASS_END
    end
  end
end