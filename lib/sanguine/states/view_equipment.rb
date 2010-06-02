module Sanguine

  module State
  
    class ViewEquipment < State
      
      attr_reader :inspect_item
      
      def initialize
        super
        @views << View::Character.new
        @views << View::Equipment.new       
        @views << View::Messages.new
      end
      
      def command(key)
        # get key pressed and try adn get item in equipment
        item = player.equipment[key.symbol]
        if item != nil
          self[:inspect_item] = item
        elsif key.symbol == :space
          game.change_state(ViewInventory.new)
        else
          game.change_state(Map.new)
        end
      end
      
    end
    
  end
  
end
