
require 'fm'

class A < FM::FMClass;end
class B < FM::FMClass;end
class C < FM::FMClass;end

a = A.new
b = B.new
c = C.new

a.is_a b

a.has_a c
a.has_a :String
a << "+ hula(pululu:int, kim:string):int"
a << "- blublu()"
a.depend "repl/base"
puts a.dump(FM::Driver::CppDriver.new)
puts a.dump(FM::Driver::JavaDriver.new)
puts a.dump(FM::Driver::RubyDriver.new)