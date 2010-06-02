module Sanguine

  module State
  
    class Target < State
       
      def initialize
        super
        @views << View::Character.new
        @views << View::Messages.new
      end
      
      # check to see that there are items to pick up and the inventory isn't full otherwise just revert state
      def activate
        self[:target] = game.get_nearest_agent(player)
        if self[:target] == nil          
          self[:target] = player
        end
        @index = 0
      end
      
      def target_next
        @index += 1
        if @index >= game.agents.length
          @index = 0
        end
        self[:target] = game.agents[@index]
      end
      
      def target_previous
        @index -= 1
        if @index < 0
          @index = game.agents.size
        end
        self[:target] = game.agents[@index]
      end
      
      def command(key)
        if key.is_direction?
          if self[:target].kind_of?(Agent)
            if self[:target].location.has_exit?(key.direction)
              self[:target] = self[:target].location.exits[key.direction]
            end
          elsif self[:target].kind_of?(Location)
            if self[:target].has_exit?(key.direction)
              self[:target] = self[:target].exits[key.direction]
            end
          end
        elsif key.symbol == :n
          self.target_next
        elsif key.symbol == :p
          self.target_previous
        end
      end
      
    end
    
  end
  
end
