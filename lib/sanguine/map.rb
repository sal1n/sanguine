module Sanguine

  # this represents an in-game map which is essentially a 2d array of locations.
  #
  class Map < GameObject
  
    # include FoV module
    include Shadowcasting
    
    attr_accessor :locations, :map
    attr_accessor :spawn_rate, :min_threat, :max_threat, :max_population, :level
    attr_accessor :portals
    
    def initialize
      @locations = Array2D.new(self.width, self.height)
      @portals = Hash.new
      parse_map
      #populate_exits
    
      # set level of creatures and items to be spawned
      game.set_level(@min_level, @max_level)
      
      # we need updates from Game to do spawns
      game.add_observer(self)
    end
    
    def width
      @map.index("\n")
    end
  
    def height
      @map.length / self.width
    end
  
    # callback for observer 
    def update 
      if game.turn % @spawn_rate == 0
        creat = game.get_random_creature
       # self.get_free_location.arrive(creat)
        @locations[2,5].arrive(creat)
      end
    end
    
    def get_free_location
      total = (@locations.width - 1) * (@locations.height - 1)
      index = rand(total)
      
      count = 0
      @locations.each do |location|
        if !location.has_agent? && location.walkable? && !location.has_portal? && count >= index
          return location
        end
        count += 1
      end
      
      self.get_free_location
    end
    
    # returns true if the tile at (x, y) vlock view of tiles beyond
    def blocked?(x, y)
      if (@locations[x, y].walkable)
        false
      else
        true
      end
    end
   
    def light(x, y)
      @locations[x, y].light
      #@locations[x, y].visible = true
      # marks (x, y) as visible to the player (e.g. lit up on screen)
    #  @locations[x, y].lit = true
    
      # simple path-finding piggybacking on LoS 
     #@locations[x, y].distance_to_player = euclidean_distance(x, y)
      #@locations[x, y].turn_last_lit = Game.instance.turn
    end
  
    def euclidean_distance(x, y)
    
      dx = x - Game.instance.player.location.x
      dy = y - Game.instance.player.location.y
    
      xs = dx * dx
      ys = dy * dy
    
      Math.sqrt(xs + ys)
    end
  
    def clear_visible
      @locations.each do |location|
        location.visible = false
      end
    end
  
  end

end