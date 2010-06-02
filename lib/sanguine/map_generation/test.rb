begin
  require 'rubygems'
rescue LoadError
end

require 'gosu'
require '../utility/array_2d'
require 'bsp_node'
require 'ascii_map'

module Sanguine
  
  # Test map generation script - generates an ascii map and displays on screen.
  #
  class TestMapGeneration < Gosu::Window

  attr_accessor :array
  
    def initialize()
      super(1060, 640, false, 20)
      self.caption = "Binary Space Partioning Dungeon Generation | Sanguine"
      
      @font = Gosu::Font.new(self, 'JSL Ancient', 16)
      
      # we assuming 1 pixel per co- ordinate, zoom this to make visible
      @zoom = 5
      
      # create root of the tree and overall size
      dungeon = MapGeneration::BSPNode.new(0, 0, 100,100)
      # recursively partition
      dungeon.partition
    
      @nodes = dungeon.to_a
      @nodes.sort! { |a,b| b.depth <=> a.depth } # sort deepest first (reverse order)
      
      @map = MapGeneration::AsciiMap.new(100,100)
      
      @nodes.each do |node|
        if node.leaf_node?
          @map.create_room(node)
        else 
          @map.create_corridor(node)
        end
      end
    end
 
    def button_down(id)
    end
  
    def draw_box(x, y, width, height, colour, z_order=0.0)
      self.draw_line(x, y, colour, x + width, y, colour, z_order)
      self.draw_line(x + width, y, colour, x + width, y + height, colour, z_order)
      self.draw_line(x, y, colour, x, y + height, colour, z_order)
      self.draw_line(x, y + height, colour, x + width, y + height, colour, z_order)
    end
  
    def draw
      Gosu::Image.from_text(self, "#{@map}", 'Courier', 20).draw(10,10, 3.0)
    end
    
  end
  
   module MapGeneration
     SmallestPartitionSize = 12
     MaxPartitionSizeRatio = 1.5
     HomogeneityFactor = 0.25
  end
  
end

w = Sanguine::TestMapGeneration.new
w.show