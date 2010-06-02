module Sanguine
 
  module View
    
    class Look < View
    
      def initialize
        super(Point.new(330, 55))
        file = File.dirname(__FILE__) + "/../../../resources/background_menu.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def tab
        @x = @x + 10
      end
      
      def draw
        super
        
        # draw background
        # @todo scale this with window size
        @background.draw(280, 0, 0)
        
        @agent = game.state[:look_agent]
        if @agent != nil
        window.write("#{@agent.name}", @x, @y, :black, window.fonts[:header])
        newline
        newline
        window.write("#{@agent.description}", @x, @y)
        newline
        end
      end
    end
    
  end
    
end       
