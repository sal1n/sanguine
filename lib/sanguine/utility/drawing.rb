module Sanguine
 
  # A (x,y) co-ordinate pair.
  #
  class Point
 
    attr_accessor :x, :y

    def initialize(x, y)
      @x, @y = x, y
    end
 
    def +(other)
      Point.new(self.x + other.x, self.y + other.y)
    end
 
    def -(other)
      Point.new(self.x - other.x, self.y - other.y)
    end
    
  end
  
  # Represents the width and height of a rectangular area.
  #
  class Size
    
    attr_accessor :width, :height
    
    def initialize(width, height)
      @width, @height = width, height
    end
    
    def smallest
      if @width <= @height
        @width
      else
        @height
      end
    end
    
  end
  
end