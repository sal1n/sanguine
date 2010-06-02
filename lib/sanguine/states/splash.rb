module Sanguine

  module State
  
    class Splash < State
       
      def initialize
        super
        @views << View::Splash.new
      end
      
      def command(key)
        game.change_state(Menu.new)
      end
      
    end
    
  end
  
end
