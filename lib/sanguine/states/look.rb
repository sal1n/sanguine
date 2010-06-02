module Sanguine

  module State
  
    class Look < Target
       
      def initialize
        super
        @map_view = View::Map.new
        @look_view = View::Look.new
        @views << @map_view    
      end
      
      def activate
        super
      end
      
      def command(key)
        if self[:look_agent] == nil
          super
          if key.symbol == :return
            self[:look_agent] = self[:target]
            @views.delete(@map_view)
            @views << @look_view
          elsif key.symbol == :escape
            game.change_state(Map.new)
          end
        else
          if key.symbol == :escape
            @views.delete(@look_view)
            @views << @map_view
            self[:look_agent] = nil
          end
        end
        
      end
      
    end
    
  end
  
end
