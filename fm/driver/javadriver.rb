

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
    private <%=elem%> _<%=elem.to_s.downcase%>;<%end%>

    public <%=@info[:self]%>(){ }
<%for mtd in @info[:methods][:public]%>
    public <%=dump_sign(mtd)%>{ }<%end%>
<%for mtd in @info[:methods][:private]%>
    private <%=dump_sign(mtd)%>{ }<%end%>
}

JAVA_CLASS_END
    end
  end
end