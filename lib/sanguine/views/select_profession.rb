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

        window.write("Select your profession..", @x, @y, :black, window.fonts[:header])
        newline
        newline
        newline
        index = 0
        game.professions.each do |profession|
          window.write("#{keys[index]} )  #{profession.name}", @x, @y)
          newline
          window.write(profession.description, @x, @y)
          newline
          index = index + 1
        end
      end
      
    end
    
  end
  
end