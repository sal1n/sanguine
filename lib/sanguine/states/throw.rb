module Sanguine

  module State
  
    class Throw < Target
       
      def initialize
        super
        @inventory_view = View::Inventory.new
        @views << @inventory_view     
      end
      
      def activate
        if player.inventory.empty?
          game.messages << "You have nothing in your inventory to throw!"
          game.change_state(Map.new)
        else
          self[:title] = 'Throw item'
          self[:instructions] = 'Press a key to inspect an item, press space to view equipment or press escape to return to map.'
          self[:items] = player.inventory
          super
        end
      end
      
      def command(key)
        if self[:item] == nil
          # get index number for key pressed and try and get item in inventory array
          if key.has_index? && key.index <= self[:items].size
            self[:item] = self[:items][key.index]
            @views.delete(@inventory_view)
            @views << View::Map.new
            game.messages << "Select creature to throw #{@item} at...press Return to throw!"
          elsif key.symbol == :escape
            game.change_state(Map.new)
          end
        else
          super
          if key.symbol == :return
            if self[:target].kind_of?(Agent)
              player.throw(self[:item], self[:target])
              game.change_state(Map.new)
            else
              messages << "Please target an agent, location targetting not yet implemented."
            end
          end
        end
        
      end
      
    end
    
  end
  
end
