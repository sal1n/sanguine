module Sanguine
  
  class Profession 
    
    attr_accessor :name, :description
    attr_accessor :health, :health_regen, :mana, :mana_regen
    attr_accessor :attack, :defence, :speed, :strikes, :stealth, :awareness
        
    def initialize
      @health = 0.0
      @health_regen = 0.0
      @mana = 0.0
      @mana_regen = 0.0
      @attack = 0
      @defence = 0
      @speed = 0
      @strikes = 0
      @stealth = 0
      @awareness = 0
    end
    
  end
  
end