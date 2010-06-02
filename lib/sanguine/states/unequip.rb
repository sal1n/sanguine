module Sanguine

  module State
  
    class Unequip < State
       
       attr_reader :inspect_item
       
      def initialize
        super
        @views << View::Character.new
        @views << View::Equipment.new       
        @views << View::Messages.new
      end
      
      def activate
        if player.equipment.length == 0
          game.messages << "You have nothing equipped."
          game.change_state(Map.new)
        end
      end
      
      def command(key)
        # get key pressed and try and get item in equipment
        item = player.equipment[key.symbol]
        if item != nil
          player.unequip(item)
          game.change_state(Map.new)
        else
          game.change_state(Map.new)
        end
      end
      
    end
    
  end
  
end
