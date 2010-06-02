module Sanguine
  
  # represents an inventory of items, currently agents
  # and locations can have inventories
  #
  # @todo should equipment really be here?  move back to player/agent
  # where i originally had it maybe.  investigate.
  #
  class Inventory < Array
    
    attr_accessor :equipment
    
    def initialize(size = 26)
      @size = size
      @equipment = Equipment.new
    end
    
    def equip(item)
      if @equipment.has_key?(item.slot)
        if item.slot == EquipmentSlot::Ammunition
          if @equipment[item.slot].equals?(item)
            @equipment[item.slot].add(self.get(item, item.quantity))
          else
            self.add(@equipment[item.slot])
            @equipment[item.slot] = self.get(item, item.quantity)
          end
        else
          self.add(@equipment[item.slot])
          @equipment[item.slot] = self.get(item)
        end
      else
        if item.slot == EquipmentSlot::Ammunition
          @equipment[item.slot] = self.get(item, item.quantity)
        else
          @equipment[item.slot] = self.get(item)
        end
      end
    end
    
    def can_fit?(item)
      if self.has_item?(item) || self.length < @size
        true
      else
        false
      end
    end
    
    def unequip(item)
      self.add(@equipment[item.slot])
      @equipment.delete(item.slot)
    end
    
    def equippable_items
      self.find_all { |i| i.equipable? } 
    end
    
    def drinkable_items
      self.find_all { |i| i.drinkable? } 
    end
    
    def space
      @size - self.length
    end
    
    def full?
      if self.length >= @size
        true
      else
        false
      end
    end
    
    def add(item)
      if self.has_item?(item)
        self[self.index(self.get_item(item))] = self.get_item(item).add(item)
      else
        self << item
      end
    end
    
    def get(item, amount = 1)
      return_item = nil
      
      my_item = self.find(item)
      
      if my_item.kind_of?(ItemStack)
        return_item = my_item.split(amount)
        if my_item.quantity == 0
          self.delete(my_item)
        elsif my_item.quantity == 1
          self[self.index(my_item)] = my_item.first
        end
        if return_item.quantity == 1
          return_item = return_item.first
        end
      else
        return_item = my_item
        self.delete(my_item)
      end
      
      return_item
    end
    
    def find(item)
      self.each do |i|
        if item.equals?(i)
          return i
        end
      end
      nil
    end
    
    # is this still used?!
    def remove(item)
      if item.kind_of?(ItemStack)
        stack = get_item(item)
        stack.remove(item)
        if stack.quantity == 0
          self.delete(stack)
        elsif stack.quantity == 1
          self[self.index(stack)] = stack.item
        end
      else
        self.delete(item)
      end
    end
    
    def has_item?(item)
      self.each do |i|
        if item.equals?(i)
          return true
        end
      end
      false
    end
    
    def get_item(item)
      self.each do |i|
        if item.equals?(i)
          return i
        end
      end
      nil
    end
    
    def to_s
      s = ""
      self.each do |item|
        if item == self.first
          s = s + "#{item}"
        elsif item == self.last
          s = s + " and #{item}"
        else
          s = s + ', ' + "#{item}"
        end
      end
      s
    end
    
  end

end
