module Sanguine

  module State
  
    class Help < State
       
      def initialize
        super
        @views << View::Help.new
      end
      
      def command(key)
        game.change_state(Menu.new)
      end
      
    end
    
  end
  
end
