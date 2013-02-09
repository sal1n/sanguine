module Sanguine
  
  # 
  class Warrior < Profession
  
    def initialize
      super
      @name = 'Warrior'
      @description = 'Conan, what is the meaning of life?'
      @health = 10
    end
  
    def level_up(player)
      player.level += 1
      player.max_health = player.base_max_health + 1000
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