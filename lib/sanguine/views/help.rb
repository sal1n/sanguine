module Sanguine
 
  module View
    
    class Help < View
      
      def initialize
        super(Point.new(380,105))
        file = File.dirname(__FILE__) + "/../../../resources/frame.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def draw
        super
        # draw background image
        @background.draw(300, 30, 0)

        window.write("Don't Panic!", @x, @y, :black, window.fonts[:header])
        newline
        newline
        window.write("Unfortunately Sanguine doesn't (yet) have an in-game help", @x, @y)
        newline
        window.write("system. A game of Junior Angler and the commands below", @x, @y)
        newline
        window.write("are the best you are going to get from me buddy;)", @x, @y)
        newline
        newline
        window.write("d - Drink a potion", @x, @y)
        newline
        window.write("e - Equip an item", @x, @y)
        newline
        newline
        newline
        newline
        newline
        window.write("Please visit http://sanguine.salin.org for up-to-date", @x, @y)
        newline
        window.write("information.", @x, @y)
      end
      
    end

  end
  
end