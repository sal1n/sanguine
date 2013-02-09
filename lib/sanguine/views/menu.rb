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
                
        window.write("<c=000000>Choose your fate..</c>", @x, @y, window.fonts[:header])
        newline
        newline
        newline
        window.write("<c=000000>a )    Create a new character</c>", @x, @y)
        newline
        newline
        window.write("<c=000000>b )    Restore a previous game</c>", @x, @y)
        newline
        newline
        window.write("<c=000000>c )    Configure key bindings</c>", @x, @y)
        newline
        newline
        window.write("<c=000000>esc )  Leave game</c>", @x, @y)
      end
      
    end

  end
  
end