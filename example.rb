
require 'fm'
class A < FM::Class::ClassBase;end
class B < FM::Class::ClassBase;end
class C < FM::Class::ClassBase;end

a = A.new
b = B.new
c = C.new

a.is_a b

a.has_a c,"CC",'rw'
a.has_a :string,'str','r'
a << "+ hula/abc(pululu:int, kim:string):int"
a << "- blublu()"
a << "= blub()"
a.depend "repl/base"
#puts a.dump(FM::Driver::CppDriver.new)
#puts a.dump(FM::Driver::JavaDriver.new)
puts a.dump(FM::Driver::RubyDriver.new)