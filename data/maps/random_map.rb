module Sanguine
  
  # Creates a random map generated using a BSP tree
  class RandomMap < Map
 
    def initialize(width, height)
      @spawn_rate = 2
      @min_threat = 1
      @max_threat = 3
      
      @key = {
        '.' => {:tile => Tile::Floor, :walkable => true},
        ' ' => {:tile => Tile::Wall, :walkable => false},
        '#' => {:tile => Tile::Wall, :walkable => false}
      }
      
      # create root of the tree and overall size
      tree = MapGeneration::BSPNode.new(0, 0, width, height)
      # recursively partition
      tree.partition
    
      # convert tree to an array
      nodes = tree.to_a
      # sort deepest first (reverse order)
      nodes.sort! { |a,b| b.depth <=> a.depth } 
      
      map = MapGeneration::AsciiMap.new(width, height)
      
      nodes.each do |node|
        if node.leaf_node?
          map.create_room(node)
        else 
          map.create_corridor(node)
        end
      end
 
      map.fix_borders
      
      @map = map.to_s
    
      super()
      
      # assign portals
      self.populate_exits
      
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
          @locations[x, y] = location
          x += 1 
        end
      end
    end
    
    def populate_exits
      up_location = self.get_free_location
      up_location.portal = Portal.new(:up, up_location)
      self.portals[:up] = up_location.portal
      down_location = self.get_free_location
      down_location.portal = Portal.new(:down, down_location)
      self.portals[:down] = down_location.portal
    end
    
  end

end