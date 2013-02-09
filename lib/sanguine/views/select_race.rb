module Sanguine

  module View
  
    class SelectRace < View
      
      def initialize
          super(Point.new(380,105))
          file = File.dirname(__FILE__) + "/../../../resources/frame.png"
          @background = Gosu::Image.new(window, file, false)
        end

      def draw
        super
        
        # draw background image
        @background.draw(300, 30, 0)

        window.write("<c=000000>Select your race..</c>", @x, @y, window.fonts[:header])
        newline
        newline
        newline
        index = 0
        game.races.each do |race|
          window.write("<c=000000>#{keys[index]} )  #{race.name}</c>", @x, @y)
          newline
          window.write("<c=000000> #{race.description}</c>", @x, @y)
          newline
          newline
          index = index + 1
        end
      end
      
    end
    
  end
  
end