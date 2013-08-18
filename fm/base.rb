
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
          :private => []
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

      def composed_by(cls)
        @comps << cls
        @deps.uniq!
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
        acl = (mtd =~ /^\b*-/)
        resolve_signature(acl,mtd)
      end

      alias_method :is_a, :inherit
      alias_method :has_a, :composed_by
      alias_method :<<, :add_method

      private

      def resolve_signature(acl = true,mtd = "")
        if mtd.empty?
          return
        else
          mtd =~ /^ \s* [+\-]?  # acl
                \s* (\w+)\s*  # method name
                \( (.*) \)    # method argument list
                :?\s*(\w+)?   # method return type
              /x
          mtd_name = $1
          mtd_args = $2.empty? ? nil : $2
          mtd_ret = $3
          if mtd_args
            mtd_args = mtd_args.split(',').map do | elem |
              pair = elem.split ':'
              { :type => pair[1].strip, :name => pair[0].strip }
            end
          end
          @methods[ acl ? :private : :public] << {
            :name => mtd_name,
            :return => mtd_ret,
            :args => mtd_args
          }
        end
      end
    end
  end
end
