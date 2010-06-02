module Sanguine
 
  module View
    
    class Chat < View
    
      def initialize
        super(Point.new(330, 55))
        file = File.dirname(__FILE__) + "/../../../resources/background_menu.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def tab
        @x = @x + 10
      end
      
      def tab_weight
        @x = @x + 500
      end
      
      def draw
        super
        
        # draw background
        # @todo scale this with window size
        @background.draw(280, 0, 0)
        
        window.write(game.state[:title],@x, @y)
        newline
      end
    end
    
  end
    
end       
