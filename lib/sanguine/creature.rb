module Sanguine

  # Represents an in-game creature (monster).
  #
  class Creature < Agent
    
    # add creature specific variables
    attr_accessor :melee_attacks, :ranged_attacks, :exp, :frequency, :threat, :min_level, :max_level
      
    # constructor
    def initialize
      super
      # a creature may have more than 1 type of attack, store both in arrays
      @melee_attacks = Array.new
      @ranged_attacks = Array.new
    end
    
    # spawn new creature in the game
    def spawn
      creature = self.clone
      # by default all creatures start inactive...
      creature.sleep
      game.add_agent(creature)
      creature
    end

    def melee_attacks_frequency_hash
      hash = Hash.new
      @melee_attacks.each do |attack|
        hash[attack] = attack.frequency
      end
      hash
    end
    
    # normalise the frequencies so they add up to 1 (within the limits of floating-
    # point arithmetic)
    def normalize_frequency_hash!(hash)
  	  sum = hash.inject(0) do |sum, object|
  	    sum += object[1]
  	  end
  	  sum = sum.to_f
  	  hash.each { |object, frequency| hash[object] = frequency / sum }
  	end
  	
    # randomly select an attack for the creature to use if it has more than one attack
    # 
    # @todo cache the normalised frequency hash
    def melee_attack
      frequency_hash = Hash.new
      @melee_attacks.each do |attack|
        frequency_hash[attack] = attack.frequency
      end
      self.normalize_frequency_hash!(frequency_hash)

      i = rand
      frequency_hash.each do |attack, frequency|
        return attack if i <= frequency
        i -= frequency
      end
    end
    
    # randomly select a ranged attack for the creature to use if it has more than one attack
    # and the attack is within range
    #
    # @note since there is a range check nil can be returned
    # @note that the @ranged_attacks hash must be normalised for this to work!
    def ranged_attack
      i = rand
      @ranged_attacks.each do |attack, frequency|
        if i <= frequency && self.location.distance_to_player <= attack.range
          return attack
        else
          i -= frequency
        end
      end
      nil
    end
    
    # all effects to be applied on strike (self + melee attack effects)
    def strike_effects
      super.concat(self.melee_attack.effects.apply_on(:strike))
    end
    
    # all effects to be applied on fire (self + ranged attack effects)
    def fire_effects
      super.concat(self.ranged_attack.effects.apply_on(:fire))
    end
    
    # the final curtain
    def die!
      super
      # generate loot
      # @todo prob want to define what kind of loot a creature can drop?
      self.location.inventory.add(game.get_random_item)   
    end
    
  end
    
  # represents a creature attack with a frequency, effects and possible range
  #
  class CreatureAttack

    attr_accessor :frequency, :effects, :range

    def initialize
      @effects = Effects.new
    end

  end
  
end     