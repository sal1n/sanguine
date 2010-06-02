module Sanguine
  
  # 
  class Warrior < Profession
  
    def initialize
      @name = 'Warrior'
      @description = 'Conan, what is the meaning of life?'
      @strength = 5
      @toughness = 5
      @agility = 0
      @intelligence = -5
      @willpower = -5
      @fellowship = 0
      @health = 10
      @mana = 0
    end
    
    def join(player)
      player.profession = self
    end
 
    def level_up(player)
      player.level += 1
      player.max_health = player.base_max_health + 1000
      player.strength = player.base_strength + 10
      
    #  Game.instance.messages << "You gain a LEVEL!  You are now level #{player.level}."
    end
    
    def title(player)
      if player.level < 3
        "Warrior"
      else
        "Blademaster"
      end
    end
    
  end
  
end
#T:Rookie
#T:Soldier
#T:Swordsman
#T:Swashbuckler
#T:Veteran
#T:Myrmidon
#T:Commando
#T:Champion
#T:Hero
#T:Lord