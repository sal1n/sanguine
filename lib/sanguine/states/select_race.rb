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
          player.attack = player.race.attack
          player.defense = player.race.defense
          player.speed = player.race.speed
          player.strikes = player.race.strikes
          player.stealth = player.race.stealth
          player.health_regen = player.race.health_regen
          player.mana_regen = player.race.mana_regen
          game.change_state(SelectProfession.new)
        elsif key.symbol == :escape
          game.change_state(Menu.new)
        end
      end
      
    end
    
  end
  
end