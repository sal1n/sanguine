module Sanguine

  module View
  
    class RollStats < View
      
      def initialize
        super(Point.new(380,105))
        file = File.dirname(__FILE__) + "/../../../resources/frame.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def tab
        @x += 100
      end

      def draw
        super
        
        # draw background image
        @background.draw(300, 30, 0)
                
        window.write("Roll your stats..", @x, @y, :black, window.fonts[:header])
        newline
        newline
        newline
        window.write("Press enter to accept or 'r' to re-roll.", @x, @y)
        newline
        newline
        window.write("Strength:", @x, @y)
        tab
        window.write("#{player.race.strength + player.profession.strength}", @x, @y)
        newline
        window.write("Toughness:", @x, @y)
        tab
        window.write("#{player.race.toughness + player.profession.toughness}", @x, @y)
        newline
        window.write("Agility:", @x, @y)
        tab
        window.write("#{player.race.agility + player.profession.agility}", @x, @y)
        newline
        window.write("Intelligence:", @x, @y)
        tab
        window.write("#{player.race.intelligence + player.profession.intelligence}", @x, @y)
        newline
        window.write("Willpower:", @x, @y)
        tab
        window.write("#{player.race.willpower + player.profession.willpower}", @x, @y)
        newline
        window.write("Fellowship:", @x, @y)
        tab
        window.write("#{player.race.fellowship + player.profession.fellowship}", @x, @y)
        newline
        newline
        window.write("Health:", @x, @y)
        tab
        window.write("#{player.race.health + player.profession.health}", @x, @y)
        newline
        window.write("Mana:", @x, @y)
        tab
        window.write("#{player.race.mana + player.profession.mana}", @x, @y)
        newline
      end
      
    end
    
  end
  
end