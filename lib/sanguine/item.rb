module Sanguine
  
  class ItemStack < Array

  def quantity
    self.length
  end
  
  def name
    self.first.name
  end
  
  def type
    self.first.kind_of?(Ammunition) ? self.first.type : nil
  end
  
  def add(item)
    if item.kind_of?(ItemStack)
      self.concat(item)
    else
      self << item
    end
  end
  
  def remove(item)
    item.each do |i|
      self.delete(i)
    end
  end
  
  def slot
    self.first.slot
  end
  
  def equipable?
    self.first.slot.nil? ? false : true
  end
  
  def drinkable?
    self.first.drinkable?
  end
  
  def weight
    self.quantity * self.first.weight
  end
  
  def effects
    self.empty? ? Effects.new : self.first.effects
  end
  
  def modifier(symbol)
    self.empty? ? 0 : self.first.modifier(symbol)
  end
  
  def equals?(item)
    self.first.name == item.name ? true : false
  end
  
  def split(amount)
    stack = ItemStack.new
    amount.times do
      stack.add(self.last)
      self.pop
    end
    stack
  end
  
  def to_s
    prefix = "a"
    suffix = ""
    if self.quantity > 1
      prefix = self.quantity
      suffix = "s"
    end
    "#{prefix} #{first.name}#{suffix}"
  end  
 
  
  
  end
  
  # represents an Item
  class Item < MapObject

    attr_accessor :name, :description
  
    attr_accessor :slot, :weight, :thrown_damage
    
    attr_accessor :value, :frequency, :min_level, :max_level
  
    def initialize
      super
      @z_order = ZOrder::Item
    end
    
    def quantity
      1
    end
    
  #  def name
   #   if @identified
   #     @name.to_s
    #  else
     #   @unknown_name.to_s
    #  end
    #end
   def add(item)
     if item.kind_of?(ItemStack)
       item.add(self)
       item
     else
       stack = ItemStack.new
       stack.add(self)
       stack.add(item)
       stack
     end
   end
  
    def to_s
      prefix = "a"
      if @name[0,1].downcase == "a"
        prefix = "an"
      end
      
    "#{prefix} #{@name}"
    end
  
    def plural_to_s
      self.to_s.split.last + "s"
    end
    
    def equals?(item)
      @name == item.name ? true : false
    end
  
    def equipable?
      @slot.nil? ? false : true
    end

    def drinkable?
      false
    end
    
  end


  class Weapon < Item
    
  end

  class RangedWeapon < Item
    
    attr_accessor :range, :target, :ammunition
    
  end
  
  class Ammunition < Item
    
    attr_accessor :type, :amount # move amount into item along generation: frequency, amount
  
  end

  class Armour < Item
  end
  
  class Ring < Item
  end
  
  class Amulet < Item
  end
  
  # throwing potions does their effect on target
  class Potion < Item
    
    def drinkable?
      true
    end
    
  end
  
end 