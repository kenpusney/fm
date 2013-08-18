
require 'fm/driver/base'
module FM
  module Class
    class ClassBase
      def initialize
        @deps = []
        @childs = []
        @comps = []
        @parent = nil
        @methods = {
          :public => [],
          :private => [],
          :static => [],
          :alias => []
        }
      end
      def dump(driver = nil)
        info =  {
          :deps => @deps,
          :childs => @childs,
          :parent => @parent,
          :methods => @methods,
          :comps => @comps,
          :self => self.to_s
        }
        if driver
          driver.dump(info)
        else
          info
        end    
      end

      ## Class Relations
      def compose(cls)
        cls.composed_by(self)
      end

      def composed_by(cls,name=nil,acl=nil)
        name ||= cls.to_s.downcase;
        @comps << {
              type: cls.to_sym,
              name: name,
              acl: acl
            }
      end

      def depend(cls)
        @deps << cls
        @deps.uniq!
      end

      def depended_by(other)
        other.depend(self)
      end

      def inherit( parent )
        parent.derive(self)
        @parent = parent
      end

      def derive(cls)
        @childs << cls
        @childs.uniq!
      end

      def to_s
        self.class.name.gsub('FM::',"");
      end

      def to_sym
        self.to_s.to_sym
      end

      def add_method(mtd)
        acl = (mtd =~ /^\s*([+\-=])/) && $1
        resolve_signature(acl,mtd)
      end

      alias_method :is_a, :inherit
      alias_method :has_a, :composed_by
      alias_method :<<, :add_method

      private

      def resolve_signature(acl = '+',mtd = "")
        if mtd.empty?
          return
        else
          mtd =~ /^ \s* [+\-=]?  # acl
                \s* (\w+)\s*  # method name
                (\/\s*(\w+)\s*)?  # method alias
                \( (.*) \)    # method argument list
                :?\s*(\w+)?   # method return type
              /x
          mtd_name = $1
          mtd_args = $4.empty? ? nil : $4
          mtd_ret = $5
          if mtd_args
            mtd_args = mtd_args.split(',').map do | elem |
              pair = elem.split ':'
              { :type => pair[1].strip, :name => pair[0].strip }
            end
          end
          acl = case acl
            when '+'
              :public
            when '-'
              :private
            when '='
              :static
            end
          @methods[ acl ] << {
            :name => mtd_name,
            :return => mtd_ret,
            :args => mtd_args
          }
          $3 and @methods[:alias] << {
            :name => $3,
            :return => mtd_ret,
            :args => mtd_args,
            :alias => mtd_name,
            :acl => acl
          }
        end
      end
    end
  end
end
