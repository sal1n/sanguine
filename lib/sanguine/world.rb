module Sanguine
  
  class World
    
    attr_accessor :maps
    
    attr_accessor :current_level
    
    def initialize
      @maps = Array.new
      @index = 0
    end
    
    # loads all Map classes
    def load
      map_classes = ObjectSpace.enum_for(:each_object, class << Map; self; end).to_a
      # remove the base class
      map_classes.delete(Map)
      
      @maps << DrownedRat.new
      self.generate
    end
     
    def change_map(destination)
      if destination == :up
        if @index > 0
          @index -= 1
        end
      elsif destination == :down
        if @index < @maps.length - 1
          @index += 1
        end
      end
      @maps[@index]
    end
    
    def generate
      1.times do |i|
        map = RandomMap.new(100, 100)
        @maps << map
      end
    end
    
  end
  
end