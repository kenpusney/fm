
require 'yaml'

module FM
  module Parser
    class BaseParser
      def initialize
        @expr = ""
        @pos = 0
        @symbols = YAML.load(File.open('./s.yml').read)[:symbols];
      end

      def parse(expr)
        @expr = expr
        while(tok = next_token)
          break if tok[0].empty? && tok[1].empty?
        end
      end

      def next_token
        return nil if @pos == @expr.length
        tok = ""
        sym = ""
        char = nil
        until @symbols.include? (char = @expr[@pos])
          p @pos+=1
          if char =~ /^\s?$/
            break if tok.length > 0
          else
            next
          end
          tok += char
        end
        return p [Token.new(tok),Token.new( @symbols[ char ] )]
      end

      def sym_table
      end

    end

    class Token
      attr_reader :tok,:childs

      def initialize(string,childs = nil)
        @tok = string
        @childs = childs;
      end

      def empty?
        return (tok == "") || (tok == nil)
      end

      def symbol?
        return tok.class == Symbol
      end
    end
  end
end
