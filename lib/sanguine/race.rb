module Sanguine

  class Race
  
    attr_accessor :name, :description
    
    # the dice used to generate each stat
    attr_accessor :strength_dice, :toughness_dice, :agility_dice, :intelligence_dice, :willpower_dice, :fellowship_dice, :health_dice, :mana_dice
    
    attr_accessor :strength, :toughness, :agility, :intelligence, :willpower, :fellowship, :health, :mana
    
    attr_accessor :health_regen, :mana_regen, :attack, :defense, :speed, :strikes, :stealth
    
  end
  
end