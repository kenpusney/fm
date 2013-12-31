
require 'fm/driver/base'
require 'fm/classbase'
module FM
  module Class
    
    class << self
      attr_reader :classes
    
      def <<(sym,&block)
        @classes = {} unless(@classes)
        @classes[sym] = FM::Class::ClassBase.new(sym.to_s.capitalize)
        if(block)
          yield sym
        end
      end

      def extends(cls,methods)

      end

      def inherits(parent,child)
      end

      def derives(child,parent)
      end

      def takes(cls,sym)
      end

      def fetch(cls)
        return @classes[cls]
      end

      private

      def [](sym)
        if @classes[sym]
          return @classes[sym]
        else
          if sym.class == Symbol
            @classes[sym] = FM::Class::ClassBase.new(sym.to_s.capitalize);
            return @classes[sym]
          else
            return nil
          end
        end
      end

      def make_method(methods)
      end

      def make_field(field)
      end
    end

  end
end
