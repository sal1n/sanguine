module Sanguine
  
  module State
    
    # this state handles the player entering the name of new characters.
    #
    # @todo offer random generated name selection
    #
    class EnterName < State
      
      def initialize
        super
        @views << View::EnterName.new
      end

      def command(key)
        if key.symbol == :return
          # only accept names 1 character or greater
          if window.text_input.text.length > 0
            # assign the name
            player.name = window.text_input.text
            # stop the text input capturing keys
            window.text_input = nil
            # change state
            game.change_state(Map.new)
          end
        elsif key.symbol == :escape
          # return to previous state
          Game.change_state(RollStats.new)
        end
      end
      
    end
    
  end
  
end