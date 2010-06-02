module Sanguine

  module State
  
    # this state handles equipping items.
    #
    class Equip < State
      
      def initialize
        super
        @views << View::Character.new
        @views << View::Inventory.new       
        @views << View::Messages.new
      end

      def activate
        if player.inventory.equippable_items.empty?
          game.messages << "You have nothing in your inventory you can equip."
          game.change_state(Map.new)
        else
          self[:title] = "Equip Item"
          self[:instructions] = "Press a key to inspect an item, press space to view equipment or press escape to return to map."
          self[:items] = player.inventory.equippable_items
        end
      end

      def command(key)
        if key.has_index? && key.index <= self[:items].size
          item = self[:items][key.index]
          player.equip(item)
          game.change_state(Map.new)
        elsif key == :space
          game.change_state(ViewEquipment.new)
        elsif key == :escape
          game.change_state(Map.new)
        end
      end
      
    end
    
  end
  
end
