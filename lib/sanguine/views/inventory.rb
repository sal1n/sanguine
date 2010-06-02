module Sanguine
 
  module View
    
    class Inventory < View
    
      def initialize
        super(Point.new(330, 55))
        file = File.dirname(__FILE__) + "/../../../resources/background_menu.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def tab
        @x = @x + 10
      end
      
      def tab_weight
        @x = @x + 500
      end
      
      def draw
        super
        
        # draw background
        # @todo scale this with window size
        @background.draw(280, 0, 0)
        
        window.write(game.state[:title],@x, @y)
        newline
        newline
        window.write(game.state[:instructions], @x, @y)
        newline
        newline
        index = 0
        game.state[:items].each do |item|
          window.write("#{keys[index]}", @x, @y)
          tab
          window.write(") #{item}", @x, @y)
          tab_weight
          window.write("#{item.weight}s", @x, @y)
          newline
          index = index + 1
        end
        if game.state[:inspect_item] != nil
          item = game.state[:inspect_item]
          newline
          window.write("Inspect Item", @x, @y)
          newline
          window.write("#{item}", @x, @y)
          newline
          window.write("#{item.description}", @x, @y)
          newline
        end
      end
    end
    
  end
    
end       
