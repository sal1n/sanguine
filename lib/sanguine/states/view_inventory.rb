module Sanguine

  module State
  
    class ViewInventory < State
       
      attr_reader :title, :instructions, :items, :inspect_item
      
      def initialize
        super
        @views << View::Character.new
        @views << View::Inventory.new     
        @views << View::Messages.new  
      end
      
      def activate
        if player.inventory.empty?
          game.messages << "You have nothing in your inventory"
          game.change_state(Map.new)
        else
          self[:title] = "Inventory"
          self[:instructions] = '[a to ' + keys[player.inventory.size - 1] + '] to inspect item, space to view equipment or any other key to return to the map.'
          self[:items] = player.inventory
        end
      end

      def command(key)
        if key.has_index? && key.index <= self[:items].size
          item = self[:items][key.index]
          if item.kind_of?(ItemStack)
            self[:inspect_item] = item.first
          else
            self[:inspect_item] = item
          end
        elsif key.symbol == :space
          game.change_state(ViewEquipment.new)
        else
          game.change_state(Map.new)
        end
      end
      
    end
    
  end
  
end
