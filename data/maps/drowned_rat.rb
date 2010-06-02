module Sanguine
  
  # The Drowned Rat Pub is the starting place for the player
  class DrownedRat < Map
 
    def initialize
      @name = 'The Drowned Rat Pub'
      @description = 'Ran by the trusty landlord Jeff, a man with a dark secret.'
      @spawn_rate = 10
      @min_threat = 1
      @max_threat = 10
      @min_level = 1
      @max_level = 10
      
      @key = {
        '.' => {:tile => Tile::Floor, :walkable => true},
        ' ' => {:tile => Tile::Wall, :walkable => false},
        '#' => {:tile => Tile::Wall, :walkable => false},
        '>' => {:tile => Tile::Floor, :walkable => true}
      }
 
@map = <<endmap
####################################################
#.......................############################
#..#....................############################
#..#.....#.###.....................................#
#..#.....#.###..........##########################.#
#..#.....#.###..........##########################.#
#..#.......###...............................>.....#
#..#.....#.###..........############################
#.......................##                          
##########################                          
endmap
 
      super
    end
  
    def parse_map
      x = y = 0
      @map.each_byte do |byte|
        if byte == 10
          y += 1
          x = 0
        else
          location = Location.new(x, y, @key[byte.chr][:tile])
          location.walkable = @key[byte.chr][:walkable]
          location.lit = false
          if byte.chr == '>'
            portal = Portal.new(:down, location)
            location.portal = portal
            @portals[:down] = portal
          end
          @locations[x, y] = location
          x +=1
        end
      end
    end
  
  end

end