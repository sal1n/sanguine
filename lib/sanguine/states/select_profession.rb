module Sanguine

  module State
  
    class SelectProfession < State
      
      def initialize
        super
        @views << View::SelectProfession.new
      end
      
      def command(key)
        if key.has_index? && key.index <= game.professions.length
          game.professions[key.index].join(player)
          game.change_state(RollStats.new)
        elsif key.symbol == :escape
          game.change_state(SelectRace.new)
        end
      end
      
    end
    
  end
  
end