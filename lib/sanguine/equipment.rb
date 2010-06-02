module Sanguine
  
  # represents the player characters equipment
  #
  # @todo need to implement 2-handed weapons, multiple rings etc
  # 
  class Equipment < Hash
    
    def add(item)
      self[item.slot] = item
    end
    
    def remove(item)
      self.delete(item.slot)
    end
    
    def effects
      effects = Effects.new
      self.each_value do |item|
        effects.concat(item.effects)
      end
      effects
    end
    
    def modifier(symbol)
      total = 0
      self.each_value do |item|
        total = total + item.modifier(symbol)
      end
      total
    end
    
    def ranged_weapon?
      if self.has_key?(EquipmentSlot::RangedWeapon)
        true
      else
          false
        end
      end

     def ranged_weapon
      self[EquipmentSlot::RangedWeapon]
    end

    def ammunition?
      if self.has_key?(EquipmentSlot::Ammunition)
          true
        else
          false
        end
    end

    def ammunition
      self[EquipmentSlot::Ammunition]
    end
    
    def ammunition_quantity
      if self.ammunition?
        self.ammunition.quantity
      else
        0
      end
    end
    
    def use_ammunition
      slot = EquipmentSlot::Ammunition
      if self[slot].kind_of?(ItemStack)
        self[slot].split(1)
        if self[slot].quantity == 0
          self.delete(slot)
        elsif self[slot].quantity == 1
          self[slot] = self[slot].first
        end
      else
        self.delete(slot)
      end
    end
    
  end
  
end