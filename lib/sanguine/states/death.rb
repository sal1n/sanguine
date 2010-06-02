module Sanguine

  module State
  
    class Death < State
       
      def initialize
        super
        @views << View::Death.new
      end
      
      def command(key)
        if key.symbol == :escape
          game.change_state(Menu.new)
        end
      end
      
    end
    
  end
  
end
