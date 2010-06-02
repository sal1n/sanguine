module Sanguine
 
  module View
    
    class View
 
      include HandyMethods
      
      # the view's location relative to the game window
      attr_accessor :location
    
      # creates a new view with a given location point
      def initialize(location)
        @location = location
        # set initial x,y positioning holders used for text output
        @x = location.x
        @y = location.y
      end
    
      def newline
        # reset the x positioning holder each newline
        @x = @location.x
        # increment the y positioning holder by the font size 
        @y = @y + Config::DefaultFontSize
      end
    
      def draw
        # reset the y positioning holder each draw
        @y = @location.y
      end
      
    end

  end
  
end
