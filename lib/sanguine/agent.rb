module Sanguine
  
  # Represents an in-game Agent, currently the base class for the Player and 
  # Creatures.
  #
  # @todo consider merging creature and player, a lot of work - need to work 
  # out gain apart from easy polymorph etc..
  #
  # @todo add_stats is class_eval'd in MapObject, prob want to change and move
  # to Agent, is this possible?
  #
  class Agent < MapObject
  
    # add health stats
    add_stats :health, :max_health, :health_regen
    
    # add mana stats
    add_stats :mana, :max_mana, :mana_regen
    
    # add base stats common to all agents
    add_stats :attack, :defense, :speed, :strikes, :stealth, :awareness
    
    # every agent has a hash containing any resistances
    attr_accessor :resistances
    
    # SkyNet is born..
    attr_accessor :ai
    
    # constructor
    def initialize
      super
      @resistances = Hash.new
      @resistances.default = 0
    end
  
    # get the agents location
    def location
      game.map.locations[@x, @y]
    end
    
    # called when the agents location is lit
    # 
    # @todo need a proximity stealth function, for now just always wake
    def check_awareness
       self.wake
    end
    
    def wake
      @active = true
    end
    
    def sleep
      @active = false
    end
    
    def active?
      @active
    end
    
    # callback for the game observer, this happens every game turn
    def update
      # regen health
      @health = @health + self.health_regen
      if @health > @max_health
        @health = @max_health
      end
      
      # regen mana
      @mana = @mana + self.mana_regen
      if @mana > @max_mana
        @mana = @max_mana
      end
      
      # apply dot effects
      @effects.damage_over_time.each do |effect|
        damage = effect.amount
        resistance = self.resistance(effect.type)
        damage = damage - (damage / 100.0 * resistance).to_i
        message = effect.message.clone
        message.gsub!(/dmg_desc/, "#{Damage.description(damage)}")
        message.gsub!(/<agent>/, "#{if self.kind_of?(Player) then "you" else "the #{@name}" end}")
        if effect.kind_of?(DamageHealth)
          message.gsub!(/<health_dmg>/, "[{red}#{damage}{black}]")
          self.take_health_damage(damage, effect.origin)
        elsif effect.kind_of?(DamageMana)
          message.gsub!(/<mana_dmg>/, "[{blue}#{damage}{black}]")
          self.take_mana_damage(damage)
        end
        messages << message
      end
      
      # update active effect durations
      @effects.update
      
    end
    
    # returns true if agent can act in current phase, else false
    def can_act?
      game.phase <= @speed ? true : false
    end
  
    def act
      @ai.act(self)
    end
    
    # movement
    #
    # @todo fov linked to successful movement...problems?
    # @todo modify fov by light source?
    # @todo handle pets and non-hotile NPC's and creatures
    def move(direction)
      # check if exit exists
      if (self.location.has_exit?(direction))
        destination = self.location.exit(direction)
        # is it walkable?
        if (destination.walkable?)
          # is it occupied
          if (destination.has_agent?)
            # for now only player<>creature strikes happen
            if self == player || destination.agent == player
              strike(destination.agent)
            end
          else
            self.location.depart(self)
            destination.arrive(self)
            # if player is moving then update the FOV
            if player == self
              game.map.clear_visible
              game.map.do_fov(destination.x, destination.y, 12)
            end
          end
        end
      end
    end 
    
    # portal between maps (hack)
    #
    # @todo integrate properly with move?
    def portal(destination)
      if self.location.has_portal? && self.location.portal.destination == destination
        self.location.depart(self)
        self.game.change_map(destination)
        if destination == :up
          self.game.map.portals[:down].location.arrive(self)
        else
          self.game.map.portals[:up].location.arrive(self)
        end
        
      end
    end
    
    # roll to hit other agent, note:
    # an attack has a 50/50 chance of hitting when attack value is 2/3 of the
    # defense value if defense is >= 3x attack then hit? always if false
    # attacker never has 100% chance to hit
    #
    # @todo this needs reworking for targeting locations etc
    def hit?(agent)
      if rand < (1.0 - (agent.defense / (3.0 * self.attack)))
        true
      else
        false
      end
    end
    
    # returns an array of all effects that this agent applies on strike  
    def strike_effects
      @effects.apply_on(:strike)
    end
      
    # strike another agent
    def strike(agent)
      # for each strike
      @strikes.times do |strike|
        # check for hit
        if self.hit?(agent)
          # it's a hit, apply the strike effects
          agent.apply(self.strike_effects, self)
        else
          if self.kind_of?(Player)
            game.messages << "You miss the #{agent.name}."
          else
            game.messages << "The #{@name} misses you."
          end
        end
      end
    end
    
    # returns an array of all effects that this agent applies on strike
    # note only player currently has a throw method
    def throw_effects
      @effects.apply_on(:throw)
    end
    
    # returns an array of all effects that this agent applies on fire
    def fire_effects
      @effects.apply_on(:fire)
    end
    
    # fire at a target
    #
    # @todo currently only Agents can be targets, include Locations, the main
    # issue is one of hit chance and applying effects to Location agents.
    def fire(target)        
      # check for hit
      if self.hit?(target)
        # it's a hit, apply the strike effects
        target.apply(self.fire_effects, self)
      else
        if self.kind_of?(Player)
          game.messages << "You miss the #{target.name}."
        else
          game.messages << "The #{@name} misses you."
        end
      end
    end
    
    # returns resistance value for a given symbol
    def resistance(symbol)
      @resistances.default = 0 # why isn't yaml preserving this?
      @resistances[symbol] + modifier(symbol)
    end
    
    # apply an effect to the agent
    def apply(effects, origin)
      
      health_damage = 0
      mana_damage = 0
      
      direct_damage_message = ""
      
      effects.direct_damage.each do |effect|
        damage = effect.amount
        resistance = self.resistance(effect.type)
        damage = damage - (damage / 100.0 * resistance).to_i
        if effect.kind_of?(DamageHealth)
          health_damage = health_damage + damage
        elsif effect.kind_of?(DamageMana)
          mana_damage = mana_damage + damage
        end
        direct_damage_message = direct_damage_message + effect.message
      end
      
      
      direct_damage_message.gsub!(/<dmg_desc>/, "#{Damage.description(health_damage)}")
      direct_damage_message.gsub!(/<agent>/, "#{if self.kind_of?(Player) then "you" else "the #{@name}" end}")
      direct_damage_message.gsub!(/<health_dmg>/, "[{red}#{health_damage}{black}]")
      direct_damage_message.gsub!(/<mana_dmg>/, "#{if mana_damage > 0 then "[{blue}]#{mana_damage}{black}]" end}")
      messages << direct_damage_message
      
      # apply the damage
      self.take_health_damage(health_damage, origin)
      self.take_mana_damage(mana_damage)
      
      radiating = Array.new

      effects.area_effects.each do |effect|
          self.location.within_radius(effect.radius, Array.new).each do |location|
            if location.has_agent? && location.agent != self
              # need to change the effect radius before affecting other agents
              effect.radius = 0
              # TODO need to stop affecting radius 0 twice e.g. player gets hit
              # double cuz the initial call plus this one
              e = Effects.new
              e << effect
              radiating << {:effect =>e, :agent => location.agent}
              #    location.agent.affect([effect], origin)
            end
            # TODO:  look into graphics!
            location.draw = Graphic.new(30)
          end
      end
 
      radiating.each do |hash|
        hash[:agent].apply(hash[:effect], hash[:agent])
      end
          
      effects.heal_effects do |effect|
        @health = @health + effect.amount
        if @health > @max_health then @health = @max_health.to_f end
      end
      
      super
      
    end
    
    # take health damage, if health falls to 0 or less then the agent dies
    def take_health_damage(amount, origin)
      @health = @health - amount
      if @health <= 0
        self.die!
        # for now only the player can gain exp
        if origin == player
          player.gain_exp(@exp)
        end
      end
    end
    
    # take mana damage
    #
    # @todo any effect for 0?
    def take_mana_damage(amount)
      @mana = @mana - amount
    end
    
    # the final curtain
    #
    # @todo consider necromancy for future? prob need to handle differently
    def die!
      @dead = true
      game.remove_agent(self)
      @effects.clear
      self.location.agent = nil
      messages << "#{@name} dies!"
    end
    
    def dead?
      @dead
    end
     
    def alive?
      ! @dead
    end
    
  end

end        