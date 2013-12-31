
require 'fm/class'
require 'fm/driver'

require 'fm/parser'

class Symbol
  undef :<
  undef :<=
  undef :>
  undef :>=
  undef :[]
  
  def <<(methods,&block)
    FM::Class.extends(self,methods)
    yield self if block
  end
  
  def <=(parent,&block)
    FM::Class.derives(self,parent)
    yield self if block
  end

  def [](sym,&block)
    obj = FM::Class.takes(self,sym)
    yield obj if block
  end

  def >=(child,&block)
    FM::Class.inherits(self,child)
    yield self if block
  end

  def fm(&block)
    return FM::Class.fetch(self)
  end

end