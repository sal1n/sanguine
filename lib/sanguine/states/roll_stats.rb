module Sanguine

  module State
  
    class RollStats < State
      
      def initialize
        super
        @views << View::RollStats.new
        # initial roll
        roll_stats
      end

      # roll the stats for the players given race
      def roll_stats
        player.race.strength = player.race.strength_dice.roll
        player.race.toughness = player.race.toughness_dice.roll
        player.race.agility = player.race.agility_dice.roll
        player.race.intelligence = player.race.intelligence_dice.roll
        player.race.willpower = player.race.willpower_dice.roll
        player.race.fellowship = player.race.fellowship_dice.roll
        player.race.health = player.race.health_dice.roll + 1000
        player.race.mana = player.race.mana_dice.roll
      end
      
      def command(key)
        if key.symbol == :r
          self.roll_stats
        elsif key.symbol == :return
          player.strength = player.race.strength + player.profession.strength
          player.toughness = player.race.toughness + player.profession.toughness
          player.agility = player.race.agility + player.profession.agility
          player.intelligence = player.race.intelligence + player.profession.intelligence
          player.willpower = player.race.willpower + player.profession.willpower
          player.fellowship = player.race.fellowship + player.profession.fellowship
          player.health = player.race.health + player.profession.health
          player.max_health = player.health
          player.mana = player.race.mana + player.profession.mana
          player.max_mana = player.mana
          game.change_state(EnterName.new)
        elsif key.symbol == :escape
          game.change_state(SelectProfession.new)
        end
      end
      
    end
    
  end
  
end
