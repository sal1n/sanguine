module Sanguine

  module State
  
    # this state handles drink operations.
    #
    class Drink < State
      
      def initialize
        super
        @views << View::Character.new
        @views << View::Inventory.new       
        @views << View::Messages.new
      end
      
      def activate
        if player.inventory.empty?
          game.messages << "You have nothing in your inventory you can drink."
          game.change_state(Map.new)
        else
          self[:title] = "Drink"
          self[:instructions] = "Press a key to drink the item or press escape to return to map."
          self[:items] = player.inventory.drinkable_items
        end
      end
      
      def command(key)
        # get index number for key pressed and try and get item in inventory array
        if key.has_index? && key.index <= self[:items].size
          item = self[:items][key.index]
          player.drink(item)
          game.change_state(Map.new)
        elsif key == :escape
          game.change_state(Map.new)
        end
      end
      
    end
    
  end
  
end
