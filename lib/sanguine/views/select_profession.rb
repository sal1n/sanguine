module Sanguine

  module View
  
    class SelectProfession < View
      
      def initialize
        super(Point.new(380,105))
        file = File.dirname(__FILE__) + "/../../../resources/frame.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def draw
        super

        # draw background image
        @background.draw(300, 30, 0)

        window.write("<c=000000>Select your profession..</c>", @x, @y, window.fonts[:header])
        newline
        newline
        newline
        index = 0
        game.professions.each do |profession|
          window.write("<c=000000>#{keys[index]} )  #{profession.name}</c>", @x, @y)
          newline
          window.write("<c=000000>#{profession.description}</c>", @x, @y)
          newline
          index = index + 1
        end
      end
      
    end
    
  end
  
end