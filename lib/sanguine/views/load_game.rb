module Sanguine
 
  module View
    
    class LoadGame < View
    
      def initialize
        super(Point.new(380,105))
        file = File.dirname(__FILE__) + "/../../../resources/frame.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def tab
        @x = @x + 10
      end
      
      
      def draw
        super
        
        # draw background image
        @background.draw(300, 30, 0)
                
        window.write(game.state[:title],@x, @y, :black, window.fonts[:header])
        newline
        newline
        window.write(game.state[:instructions], @x, @y)
        newline
        newline
        index = 0
        game.state[:saved_games].each do |item|
          window.write("#{keys[index]}", @x, @y)
          tab
          window.write(") #{item}", @x, @y)
          newline
          index = index + 1
        end
      end
    end
    
  end
    
end       
