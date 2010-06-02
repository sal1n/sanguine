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
    
    # used to dynamically add stat methods to the class at runtime
    def self.add_stats(*stats) 
      stats.each do |stat|
        code = %Q{ 
          def #{stat} 
            if @#{stat} + modifier('#{stat}'.to_sym) < 0
              0
            else
              @#{stat} + modifier('#{stat}'.to_sym)
            end
          end 
        
          def #{stat}=(value)
            @#{stat} = value
          end
        
          def base_#{stat} 
            @#{stat} 
          end
        } 
        class_eval(code) 
      end
    end

  end
  
end
