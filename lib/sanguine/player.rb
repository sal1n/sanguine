module Sanguine
  
  class Memory
    
    def initialize
      @identified_items = Array.new
      @log = Hash.new
    end
    
    def identify(item)
      if ! self.identified?(item)
        @identified_items << item
      end
    end
    
    def identified?(item)
      @identified_items.each do |i|
        if item.equals?(i)
          return true
        end
      end
      false
    end
  
  end
  
  # represents the Player character in the game
  class Player < Agent
  
    attr_accessor :race, :profession, :exp, :total_exp, :level, :inventory, :memory
    
    add_stats :strength, :toughness, :agility, :intelligence, :willpower, :fellowship

    def initialize
      super
      @tile = Tile::Character
      @inventory = Inventory.new
      @exp = 0
      @total_exp = 0
      @level = 1
      @memory = Memory.new
      @inventory.add(game.items.get_item_by_name("dagger"))
      self.equip(@inventory.first)
      game.add_observer(self) # move to game add_player?
    end
    
    def modifier(symbol)
      # first get all modifiers given by effects on the agent
      total = self.effects.modifier(symbol)
      # add all the modifiers given by equipment
      total = total + self.equipment.modifier(symbol)
      total  #tODO is this necessary or will it return just last 
    end
    
    # returns resistance value for a given symbol
    def resistance(symbol)
      @resistances[symbol] + self.modifier(symbol) + self.equipment.modifier(symbol)
    end
    
    # all effects on strike (self + equipment effects)
    def strike_effects
      super.concat(self.equipment.effects.apply_on(:strike))
    end

    # all effects on strike (self + equipment effects)
    def fire_effects
      super.concat(self.equipment.effects.apply_on(:fire))
    end
    
    def fire(target)
      # remove ammunition
      self.equipment.use_ammunition
      
      # TODO: decide whether to implement this
      # have xp bonus plus IMPERIAL STORMTROOPER MEssage 1/10000 chance when miss
       #random = 0.001
      # if random > 0.9999
       #  messages << "Only Imperial Stormtroopers are so precise!"
         # gain xp
      # end
       
      super(target)
    end
    
    def damage_output
      min = 0
      max = 0
      self.strike_effects.each do |effect|
        if effect.kind_of?(Damage)
          min = min + effect.min
          max = max + effect.max
        end
      end
      "#{min} - #{max}"
    end
    
    def ranged_damage_output
      min = 0
      max = 0
      self.fire_effects.each do |effect|
        if effect.kind_of?(Damage)
          min = min + effect.min
          max = max + effect.max
        end
      end
      "#{min} - #{max}"
    end
    
    def gain_exp(amount)
      
      @exp += amount
      @total_exp += amount
      
      if self.level?
        self.level_up
      end
      
    end
    
    def exp_needed
      self.sum(@level) * 50 - @exp
    end
    
    def level?
      @exp >= self.sum(@level) * 50 ? true : false
    end
    
    def sum(n)
      if n == 0
        0
      else
        n + sum(n - 1)
      end
    end
    
    def level_up
      @exp -= self.sum(@level)
      @profession.level_up(self)
    end
    
    def throw(item, target)
       # get the item from the inventory
      item = @inventory.get(item)

      # get the items on throw effects
      effects = item.effects.apply_on(:throw)

      # potions apply their on_self effects on_throw
      if item.kind_of?(ItemStack)
        if item.first.kind_of?(Potion)
          effects = item.effects.apply_on(:self)
        end
      elsif item.kind_of?(Potion)
        effects = item.effects.apply_on(:self)
      end

      # concat the effects of the item with any self on_throw effects
      effects.concat(self.throw_effects)

      # check for hit
      if self.hit?(target)
        target.apply(effects, self)
      end
      
    end
    
    def cast(spell)
    end
  
    def get(item, amount = 1)
      if @inventory.can_fit?(item)
        items = self.location.inventory.get(item, amount)
        @inventory.add(items)
        messages << "You get #{items}."
      else
        messages << "You have no room in your inventory for #{item}!"
      end
    end
    
    def drop(item, amount = 1)
      items = @inventory.get(item, amount)
      self.location.inventory.add(items)
      messages << "You drop #{items}."
    end
    
    def equipment
      @inventory.equipment
    end
    
    def weapon
       self.equipment[EquipmentSlot::Weapon]
    end
    
    def equip(item)
      @inventory.equip(item)
    end
    
    def unequip(item)
      @inventory.unequip(item)
    end
    
    def drink(item)
      item = @inventory.get(item)
      messages << "You drink the #{item}"
      self.apply(item.effects.apply_on(:self), self)
      # identify the item (if not already)
      item.identify
    end
    
    # the final curtain
    def die!
      super
      # change state!
      game.change_state(State::Death.new)
    end
    
  end
  
  
end
