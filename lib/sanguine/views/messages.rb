module Sanguine

  module View
    
    class Messages < View
      
      def initialize
        super(Point.new(320,580))
        file = File.dirname(__FILE__) + "/../../../resources/background_messages.png"
        @background = Gosu::Image.new(window, file, false)
      end
      
      def draw
        # draw background image
        @background.draw(280, Config::ScreenHeight - 145, 0, 1.0, 1.0)
        
        i = 0
        game.messages.last(6).each do |message|
          window.write(message, @location.x, @location.y + i)
          i += Config::DefaultFontSize
        end
      end
    
      def last_x
      end
      
    end
  
  end
  
end

