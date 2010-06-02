module Sanguine

  # Represents a dice which can be rolled, initialised with a string
  # e.g. "1d5 + 10" or "-1d4" etc.
  #
  # With thanks to Pablo Hoch, Ruby Quiz #61.
  #
  class Dice

    def initialize(expression)
      @roll = expression.to_s
    end
  
    # class method
    def self.roll(expression)
      to_rpn(expression.to_s).roll
    end

    def roll
      stack = []
      to_rpn(@roll).each do |token|
        case token
          when /\d+/
            stack << token.to_i
          when /[-+*\/d]/
            b = stack.pop
            a = stack.pop
            stack << a.send(token.to_sym, b)
        end
      end
      stack.pop
    end
  
    private
  
    def to_rpn(infix)
      stack, rpn, last = [], [], nil
      infix.scan(/\d+|[-+*\/()d%]/) do |token|
        case token
          when /\d+/
            rpn << token
          when '%'
            rpn << "100"
          when /[-+*\/d]/
            while stack.any? && stronger(stack.last, token)
              rpn << stack.pop
            end
            rpn << "1" unless last =~ /\d+|\)|%/
            stack << token
          when '('
            stack << token
          when ')'
            while (op = stack.pop) && (op != '(')
              rpn << op
            end
        end
        last = token
      end
      while op = stack.pop
        rpn << op
      end
      rpn
    end
  
    def stronger(op1, op2)
      (op1 == 'd' && op2 != 'd') || (op1 =~ /[*\/]/ && op2 =~ /[-+]/)
    end
  
  end

end

# Yay Ruby;)
# 
class Fixnum
  def d(b)
    (1..self).inject(0) {|s,x| s + rand(b) + 1}
  end
end
