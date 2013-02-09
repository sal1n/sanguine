module Sanguine

  module View
    
    class Messages < View
      
      def initialize
        super(Point.new(300, Config::ScreenHeight - 130))
      end
      
      def draw
        # draw background image
        window.draw_box(300, Config::ScreenHeight - 130, Config::ScreenWidth - 310, 120, window.gosu_colour(:border))
            #   @background.draw(20, Config::ScreenHeight - 145, 0, 0.5, 1.0)
        #@background.draw(300, Config::ScreenHeight - 145, 0, 1.0, 1.0)
       # window.draw_box(260,580,1,90, window.gosu_colour(:black))
        i = 10
        alpha = ["ff", "cc", "bb", "99", "66", "33"]
        index = 0
        game.messages.last(6).reverse.each do |message|
          msg = "<c=ffffff>#{message}</c>"
          msg.gsub!(/c=/, "c=#{alpha[index]}")
          window.write(msg, @location.x + 10, @location.y + i)
          i += Config::DefaultFontSize
          index += 1
        end
      end
    
      def last_x
      end
      
    end
  
  end
  
end

