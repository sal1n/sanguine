module Sanguine

  module State
  
    class SelectProfession < State
      
      def initialize
        super
        @views << View::SelectProfession.new
      end
      
      def command(key)
        if key.has_index? && key.index <= game.professions.length
          player.profession = game.professions[key.index]
          game.change_state(EnterName.new)
        elsif key.symbol == :escape
          game.change_state(SelectRace.new)
        end
      end
      
    end
    
  end
  
end