module Sanguine
  
  module State
    
    # this state handles drop operations. it uses a TextField to capture amounts when required.
    #
    class Drop < State
      
      def initialize
        super
        @views << View::Character.new
        @views << View::Inventory.new
        # need a reference to the message view so can position the textfield correctly
        @message_view = View::Messages.new
        @views << @message_view
        
        # default amount message
        @amount_message = "How many? (just press enter for all) "
        # get width of amount message for textfield positioning
        width = window.font.text_width(@amount_message)
        # instantiate textfield, this will only become active depending on current state i.e., for amounts
        @text_field = View::TextField.new(window, window.font, @message_view.location.x + width, @message_view.location.y + 83)
        @views << @text_field
      end

      def activate
        if player.inventory.empty?
          messages << "You have nothing in your inventory to drop"
          game.change_state(Map.new)
        else
          self[:title] = "Drop Item"
          self[:instructions] = "Press a key to drop an item."
          self[:items] = player.inventory
        end
      end
      
      def command(key)
        if key.has_index? && key.index <= self[:items].size
          @item = self[:items][key.index]
          if @item.kind_of?(ItemStack)
            messages << @amount_message
            # make textfield active
            window.text_input = @text_field
          else
            player.drop(@item)
            game.change_state(Map.new)
          end
        elsif key.symbol == :return && window.text_input != nil
          amount = 0
          if window.text_input.text.to_i > 0 && window.text_input.text.to_i <= @item.quantity
            amount = window.text_input.text.to_i
          else
            amount = @item.quantity
          end
          messages.append_to_last(amount.to_s)
          
          player.drop(@item, amount)

          # deactivate textfield
          window.text_input = nil 
          game.change_state(Map.new)
        else
          # deactivate textfield
          window.text_input = nil
          game.change_state(Map.new)
        end
      end
      
    end 
    
  end 
  
end