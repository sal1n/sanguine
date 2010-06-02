module Sanguine

  module State
  
    # handles firing, subclass of Target.
    #
    # @todo implement location targeting!!!
    #
    class Fire < Target
       
      def initialize
        super
        @views << View::Map.new   
      end
      
      # check to see that there are items to pick up and the inventory isn't full otherwise just revert state
      def activate
        if player.equipment.ammunition?
            super
        else
            messages << "You don't have ammunition equipped for your #{player.equipment.ranged_weapon}."
           game.change_state(Map.new)
        end
      end
      
      def command(key)
        super
        if key.symbol == :return
          if self[:target].kind_of?(Agent)
            player.fire(self[:target])
            game.change_state(Map.new)
          else
            messages << "Please target an agent, location targetting not yet implemented."
          end
        end
      end
      
    end
    
  end
  
end
