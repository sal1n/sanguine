module Sanguine

  # Base class of all in-game map objects, a map object has a tile and a colour
  #
  # @todo move add_stats to agent, it that possible? investigate
  #
  class MapObject < GameObject
    
    # co-ordinates of the map object
    attr_accessor :x, :y
    
    # display attributes
    attr_accessor :tile, :colour

    # constructor
    def initialize
      super
    end

  end
  
end
