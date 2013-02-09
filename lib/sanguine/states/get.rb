module Sanguine
  
  module State
    
    # this state is activated when the :g key is pressed and handles get operations. it uses a TextField
    # to capture amounts when required.
    class Get < State
      
      def initialize
        super
        @views << View::Character.new
        @views << View::Map.new
        # need a reference to the message view so can position the textfield correctly
        @message_view = View::Messages.new
        @views << @message_view
        
        # default amount message
        @amount_message = "How many? (just press enter for all) "
        # get width of amount message for textfield positioning
        width = window.font.text_width(@amount_message)
        # instantiate textfield, this will only become active depending on current state i.e., for amounts
        @text_field = View::TextField.new(window, window.font, @message_view.location.x + width + 10, @message_view.location.y + 10)
        @views << @text_field
      end
      
      # check to see that there are items to pick up and the inventory isn't full otherwise just revert state
      def activate
        if player.location.has_items?
          # set inventory index being considered for get
          @index = 0
          @item = player.location.inventory[@index]
          if player.inventory.can_fit?(@item)
            if player.location.inventory.size == 1 && @item.quantity == 1
              # a single item at the location so just get it
              player.get(@item)
              game.change_state(Map.new)
            else
              game.messages << "Do you want to pick up #{@item}? Y/N"
            end
          else
            game.messages << 'Your inventory is full.'
            game.change_state(Map.new)
          end
        else
          # no items at location
           game.change_state(Map.new)
        end
      end
    
      # checks if any other items to be considered otherwise reverts state back to the map
      def next_item
        if (player.location.inventory.length > @index)
          @item = player.location.inventory[@index]
          game.messages << "Do you want to pick up #{@item}? Y/N"
        else
          game.change_state(Map.new)
        end
      end
      
      def command(key)
        if key.symbol == :y
          game.messages.append_to_last('Y')
          if @item.kind_of?(ItemStack)
            game.messages << @amount_message
            # remove any old commands
            @text_field.text = ""
            # make textfield active
            window.text_input = @text_field
            
          else  
            # not a stack so just get it
            player.get(@item)
            next_item
          end
        elsif key.symbol == :n
          game.messages.append_to_last('N')
          # since we haven't got the last item we need to increment the index to consider the next item in the array
          @index = @index + 1
          next_item
        elsif key.symbol == :return && window.text_input != nil
          amount = 0
          if window.text_input.text.to_i > 0 && window.text_input.text.to_i < @item.quantity
            amount = window.text_input.text.to_i
            # since we have left some items increment the index
            @index = @index + 1
          else
            amount = @item.quantity
          end
          game.messages.append_to_last(amount.to_s)
          
          player.get(@item, amount)
          
          # deactivate textfield
          window.text_input = nil
          next_item  
        else
          # deactivate textfield
          window.text_input = nil
          game.messages.append_to_last('N')
          game.change_state(Map.new)
          game.state.command(key)
        end
        
      end
      
    end 
    
  end 
  
end