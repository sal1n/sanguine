module Sanguine
  
  class Graphic
    
    attr_accessor :duration
    
    def initialize(duration)
      @duration = duration
    end
    
    def draw
    end
    
  end
  
  class Portal < MapObject
    
    attr_accessor :destination, :map, :location
    
    def initialize(destination, location)
      @destination = destination
      @location = location
    end

    def use
      new_map = world.maps[to_map]
    end
    
    
  end
  
  # represents a Location in the game - a game tile in the display
  class Location < MapObject

    # co-ordinates of the location on the Map object
    attr_accessor :draw
    
    # boolean flags
    attr_accessor :walkable, :visible, :lit
    
    # fov pathfinding
    attr_accessor :turn_last_lit, :distance_to_player
    
    # does the location contain an Agent?
    attr_accessor :agent
    
    # every location can act as an inventory
    attr_accessor :inventory
    
    # a location may contain a portal (a link between 2 locations on different
    # maps) e.g. stairs
    attr_accessor :portal
    
    def initialize(x, y, tile)
      super()
      @tile = tile
      @z_order = ZOrder::Location
      @x = x
      @y = y
      
      # consider lazy instantiation to save memory?
      @inventory = Inventory.new
    end
    
    # when the location is lit check for awareness etc
    def light
      @lit = true
      
      @visible = true
      @distance_to_player = self.distance(player.location)
      @turn_last_lit = game.turn
      if self.has_agent? && @agent != player && ! @agent.active?
        @agent.check_awareness
      end
    end
    
    # use this method to add an agent to the location
    def arrive(agent)
      @agent = agent
      agent.x = @x
      agent.y = @y
     # agent.location = self
      if @agent == player && has_items?
        game.messages << "You see #{@inventory} here."
      end
    end
  
    # use this method to remove an agent from the location
    def depart(agent)
      @agent = nil
    end
    
    def walkable?
      @walkable
    end
    
    def visible?
      @visible
    end
      
    def lit?
      @lit
    end
    
    def exit(direction)
      if (direction == :north_west) && ((@y > 0) && (@x > 0))
        game.map.locations[@x - 1, @y - 1]
      elsif (direction == :north) && (@y > 0)
        game.map.locations[@x, @y - 1]
      elsif (direction == :north_east) && ((@y > 0) && (@x < game.map.width - 1))
        game.map.locations[@x + 1, @y - 1]
      elsif (direction == :east) && (@x < game.map.width - 1)
        game.map.locations[@x + 1, @y]
      elsif (direction == :south_east) && ((@y < game.map.height - 1) && (@x < game.map.width - 1))
        game.map.locations[@x + 1, @y + 1]
      elsif (direction == :south) && (@y < game.map.height - 1)
        game.map.locations[@x, @y + 1]
      elsif (direction == :south_west) && ((@y < game.map.height - 1) && (@x > 0))
        game.map.locations[@x - 1, @y + 1]
      elsif (direction == :west) && (@x > 0)
        game.map.locations[@x - 1, @y]
      else
        nil
      end
  end
  
    def exits
      exits = Hash.new
      if self.has_exit?(:north_west)
        exits[:north_west] = self.exit(:north_west)
      end
      if self.has_exit?(:north)
        exits[:north] = self.exit(:north)
      end
      if self.has_exit?(:north_east)
        exits[:north_east] = self.exit(:north_east)
      end
      if self.has_exit?(:east)
        exits[:east] = self.exit(:east)
      end
      if self.has_exit?(:south_east)
        exits[:south_east] = self.exit(:south_east)
      end
      if self.has_exit?(:south)
        exits[:south] = self.exit(:south)
      end
      if self.has_exit?(:south_west)
        exits[:south_west] = self.exit(:south_west)
      end
      if self.has_exit?(:west)
        exits[:west] = self.exit(:west)
      end
      exits
    end
    
    def has_exit?(direction)
      ! self.exit(direction).nil?
    end
    
    def has_agent?
      ! @agent.nil?
    end
    
    def has_items?
      ! @inventory.empty?
    end
  
    def has_portal?
      ! @portal.nil?
    end
    
    def within_radius(radius, locations)
      locations << self
      if radius > 0
        self.exits.each_value do |location|
          if ! locations.include?(location)
            location.within_radius(radius - 1, locations)
          end
        end        
      end
      locations
    end
  
    def apply(effect, origin)
      if self.has_agent?
        @agent.apply(effect, origin)
      end
    end

    def random_exit
      index = 1 + rand(@exits.size)
      @exits[index]
    end
    
    # euclidean distance between this location and given location
    def distance(location)
      dx = @x - location.x
      dy = @y - location.y
    
      dx = dx * dx
      dy = dy * dy
      
      Math.sqrt(dx + dy)
    end
    
    def co_ords
      "#{@x} , #{@y}"
    end
    
  end

end