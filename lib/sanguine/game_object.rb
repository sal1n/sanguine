module Sanguine
  
  # base class of all in-game objects.
  #
  class GameObject
  
    # give every game object access to handy methods
    include HandyMethods
    
    # every game object has a name and description
    attr_accessor :name, :description
    
    # constructor
    def initialize
     # @effects = Effects.new
    end
    
    # all game objects can have effects, lazy instantiation
    def effects
      if @effects.nil?
        @effects = Effects.new
      else
        @effects
      end
    end
     
    def effects=(value)
      @effects = value
    end
    
    # call this method to apply an array of effects on the game object
    def apply(effects, origin)
      effects.each do |effect|
        if ! effect.active?
          # activate the effect
          effect.activate(origin)
          # don't add instant effects to the object
          if effect.duration > Duration::Instant
            if !@effects.has_effect?(effect)
              if self == player
                messages << effect.apply_message
              end
              @effects.add(effect)
            end
          end
        end
      end
    end
    
    # return the sum of all modifiers for the given symbol
    def modifier(symbol)
      # map objects only have direct effects modifying them
      self.effects.modifier(symbol)
    end
    
  end
  
end
