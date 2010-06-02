module Sanguine

  module View
  
    class Item < View
      
      attr_accessor :item
      
      def initialize(origin, size)
        super
      end
      
      def draw
         GameWindow.instance.font.draw(@item.name, @origin.x, @origin.y, 1.0, 1, 1, 0xffffffff)
         GameWindow.instance.font.draw(@item.description, @origin.x, @origin.y+64,1.0)
      end
      
    end
    
  end
  
end