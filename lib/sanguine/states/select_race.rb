module Sanguine

  module State
  
    class SelectRace < State
      
      def initialize
        super
        @views << View::SelectRace.new
      end

      def command(key)
        if key.has_index? && key.index <= game.races.length
          player.race = game.races[key.index]
          game.change_state(SelectProfession.new)
        elsif key.symbol == :escape
          game.change_state(Menu.new)
        end
      end
      
    end
    
  end
  
end