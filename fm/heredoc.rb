
module FM
    module Heredoc
Cpp_class_template=<<CPP_CLASS_END
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

Java_class_template=<<JAVA_CLASS_END
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

Ruby_class_template=<<RUBY_CLASS_END
<%for dep in @info[:deps]%>
<%unless @reserved.include? dep.to_sym %>require '<%=dep%>'<%end%><%end%>

class <%=@info[:self]%><%= (@info[:parent])? " < " : ""%><%=@info[:parent]%>
  def initialize<%for elem in @info[:comps]%>
    @<%=elem.to_s.downcase%>=<%=elem%>.new<%end%>
  end
<%for mtd in @info[:methods][:public]%>
  def <%=dump_sign(mtd)%>

  end<%end%>

private
<%for mtd in @info[:methods][:private]%>
  def <%=dump_sign(mtd)%>

  end<%end%>
end
RUBY_CLASS_END
    end
end