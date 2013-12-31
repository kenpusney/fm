
require 'fm'
class A < FM::Class::ClassBase;end
class B < FM::Class::ClassBase;end

a = A.new
b = B.new
c = FM::Class::ClassBase.new('C')

a <= b

a.has_a c,"CC",'rw'
a.has_a :string,'str','r'
a << "+ hula/abc(pululu:int, kim:string):int"
a << "- blublu()"
a << "= blub()"
a < "repl/base"
puts a.dump(FM::Driver::JavaDriver.new)


# FM::Parser::BaseParser.new.parse("a1")