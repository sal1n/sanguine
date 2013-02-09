module Sanguine
 
  module View
    
    class Death < View
      
      def initialize
        super(Point.new(320, 20))
      end
      
      def draw
        super
        window.write("Death comes to us all...", @x, @y)
        newline
        newline
        window.write("Press escape to return to the menu", @x, @y)
      end
      
    end

  end
  
end