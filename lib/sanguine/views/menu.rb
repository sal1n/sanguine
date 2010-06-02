module Sanguine
 
  module View
    
    class Menu < View
      
      def initialize
        super(Point.new(380,105))
        file = File.dirname(__FILE__) + "/../../../resources/frame.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def draw
        super
        
        # draw background image
        @background.draw(300, 30, 0)
                
        window.write("Choose your fate..", @x, @y, :black, window.fonts[:header])
        newline
        newline
        newline
        window.write("a )    Create a new character", @x, @y)
        newline
        newline
        window.write("b )    Restore a previous game", @x, @y)
        newline
        newline
        window.write("c )    Don't Panic!", @x, @y)
        newline
        newline
        window.write("esc )  Leave game", @x, @y)
      end
      
    end

  end
  
end