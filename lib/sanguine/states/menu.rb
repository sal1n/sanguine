module Sanguine

  module State
  
    class Menu < State
       
      def initialize
        super
        @views << View::Menu.new
      end
      
      def command(key)
        if key.symbol == :a
          game.player = Player.new
          game.map.locations[1,5].arrive(game.player)
          game.map.do_fov(game.player.x, game.player.y, 12)  # this really shouldn't be here
          game.change_state(SelectRace.new)
        elsif key.symbol == :b
          game.change_state(LoadGame.new)
        elsif key.symbol == :c
          game.change_state(Help.new)
        elsif key.symbol == :escape
          window.close
          puts("Goodbye and thanks for playing!")
        end
      end
      
    end
    
  end
  
end
