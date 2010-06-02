module Sanguine
  
  # every game object has an effects array, this updates every
  # game turn to keep track of effect durations.
  #
  class Effects < Array
    
    include HandyMethods
    
    # constructor
    def initialize
      
    end
    
    def clone
      effects = Effects.new
      self.each do |effect|
        effects << effect.clone
      end
      effects
    end
    
    def add(effect)
      if self.has_effect?(effect)
        # do i want to cumulate the duration or do nothing?!
      else
        self << effect
      end
    end
    
    def has_effect?(effect)
      if effect.has_name?
        self.each do |e|
          if effect.name == e.name
            return true
          end
        end
      end
      false
    end
    
    def apply_on(symbol)
      effects = Effects.new
      self.each do |effect|
        if effect.apply_on == symbol
          effects.add(effect.clone)
        end
      end
      effects
    end
    
    def temporary
      array = Array.new
      self.each do |effect|
        if effect.duration > 0 && effect.apply_on == :self
          array << effect.clone
        end
      end
      array
    end
    
    def direct_damage
      effects = Effects.new
      self.each do |effect|
        if effect.kind_of?(Damage) && effect.duration == Duration::Instant
          effects.add(effect)
        end
      end
      effects
    end
    
    def damage_over_time
      effects = Effects.new
      self.each do |effect|
        if effect.kind_of?(Damage) && effect.duration > 0
          effects.add(effect)
        end
      end
      effects
    end
    
    def heal_effects
      effects = Effects.new
      self.each do |effect|
        if effect.kind_of?(Heal)
          effects.add(effect)
        end
      end
      effects
    end
    
    def area_effects
      effects = Effects.new
      self.each do |effect|
        if effect.has_radius?
          effects.add(effect)
        end
      end
      effects
    end
    
    # callback for observer 
    def update 
      self.each do |effect|
        if effect.active? && effect.duration != Duration::Permanent
          # we need to remove 1 turn before to start the index from 1 for nicer display
          if (effect.duration == Duration::Instant + 1)
            self.delete(effect)
          else
            effect.duration = effect.duration - 1
          end
        end
      end
    end
    
    # get total effect modifier value for a given stat
    def modifier(stat)
      total = 0
      self.each do |effect|
        if effect.kind_of?(ModifyStat)
          if effect.stat == stat
            total = total + effect.amount
          end
        end
      end
      total
    end
    
    def self.load(yaml, apply_on)
      effects = Effects.new
      yaml.each do |effect|
        effects.add(self.load_effect(effect, apply_on))
      end
      effects
    end
    
  end
  
end