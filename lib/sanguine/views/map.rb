module Sanguine

  module View
    
  class Map < View
    
    def initialize
      super(Point.new(285,0))
      @width = Config::ScreenWidth - 285  # width of character view
      @height = Config::ScreenHeight - 100  # height of message view
    end
    
    # for performance we want to just calculate the visible x,y tiles rather
    # than iterate thro' the entire map
    def visible_tiles
      frame_x = (((@width - Config::TileWidth) / Config::TileWidth) ).to_i
      frame_y = (((@height - Config::TileHeight) / Config::TileHeight) ).to_i
      
      
      start_x = player.location.x - (frame_x / 2).to_i
      start_y = player.location.y - (frame_y / 2).to_i
      
      if start_x < 0
        start_x = 0
      end
      if start_y < 0
        start_y = 0
      end
      
      tiles = Array.new
      
      frame_x.times do |i|
        frame_y.times  do |j|
          if (start_x + i < game.map.width ) && (start_y + j < game.map.height )
         #  puts("start_x is #{start_x} and start_y is #{start_y} and i is #{i} and j is #{j}")
             tiles << game.map.locations[start_x + i, start_y + j]
           end
        end
      end
      
      tiles
      
    end
    
    def draw

      frame_x = (((@width - Config::TileWidth) / Config::TileWidth) / 2).to_i
      frame_y = (((@height - Config::TileHeight) / Config::TileHeight) / 2).to_i
        
      @view_origin_x = player.location.x - frame_x
      @view_origin_y = player.location.y - frame_y

      
     # surrounding = self.size.width - tilewidth / tilewidth (round down)
     #self.origin.x = (Config::ScreenWidth / 2) - (13 * 24)
   # max =  (600 / 2) - (player.location.x * Config::TileWidth)
    # ax = (600 / 2) - (player.location.y * Config::TileHeight)
    
   #     @anchor_x = min(max(0, Game.instance.player.location.x - self.size.width/2), (13*24) - self.size.width)
 #    @anchor_y = min(max(0, Game.instance.player.location.y - self.size.height/2), (12*40) - self.size.height)
      # for performance just index by [x][y] and draw
      self.visible_tiles.each do |location|
      #game.map.locations.each do |location|
       # if (location.x >= player.location.x - frame_x && location.x <= player.location.x + frame_x)
        #  if (location.y >= player.location.y - frame_y && location.y <= player.location.y + frame_y)
            if (location.lit?)
  
        x = ((location.x - @view_origin_x) * Config::TileWidth) + @location.x
        y = ((location.y - @view_origin_y) * Config::TileHeight) + @location.y
        
        window.tiles[location.tile].draw(x, y, ZOrder::Location, 1, 1)
        
        if location.draw != nil && location.draw.duration > 0
          window.tiles[Tile::Explosion].draw(x,y, 10.0,1 ,1)
         # window.draw_box(x,y, Config::TileWidth, Config::TileHeight, Colour::White, 5.0)
          location.draw.duration = location.draw.duration - 1
        end
        
        if (location.visible?)
          if  game.state[:target] == location
             window.draw_box(x, y, Config::TileWidth, Config::TileHeight, 5.0)
           end
           
       if (location.has_items?)
          item = location.inventory.first
          if item.kind_of?(ItemStack)
            item = item.first
          end
         window.tiles[item.tile].draw(((location.x - @view_origin_x) * Config::TileWidth) + @location.x, 
            ((location.y - @view_origin_y) * Config::TileHeight) + @location.y, ZOrder::Item, 1, 1)
        end
      
        if location.has_portal?
          if location.portal.destination == :up
            t = Tile::StairsUp
          else
            t = Tile::StairsDown
          end
          window.tiles[t].draw(((location.x - @view_origin_x) * Config::TileWidth) + @location.x, 
          ((location.y - @view_origin_y) * Config::TileHeight) + @location.y, 2.0, 1, 1)
        end
        
        if (location.has_agent?)
          agent = location.agent
          window.tiles[agent.tile].draw(((location.x - @view_origin_x) * Config::TileWidth) + @location.x, 
            ((location.y - @view_origin_y) * Config::TileHeight) + @location.y, ZOrder::Agent, 1, 1, window.gosu_colour(:red))
            
                  if game.state[:target] == agent
                     window.draw_box(x, y, Config::TileWidth, Config::TileHeight, Colour::White, 5.0)
                   end
        end
      end
      end
      end
      #end
     # end
    end
    
  end
  
  end
  
end
