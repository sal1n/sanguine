# AI
#
# @todo implement some non-basic AI
#
# @todo investigate alternative pathfinding re Ruby and performance issues
#
# @todo investigate multiple fov's
#
module Sanguine

  # Base class for all AI.
  #
  # Whenever fov calls location.light() the turn number and distance to player
  # are stored.
  # 
  # If a creature wants to find his way to the player it checks its location
  # and all the location exits.  if it's location was seen by the player on her
  # most recent turn it knows it has LoS.  
  #
  # To chase the player the creature just moves to the location that was seen
  # most recently by the player.  if more than one location has the same recent
  # turn then the creature moves to the location with the shortest stored
  # distance to the player.
  #
  # This is simple and more importantly fast.  idea from Jeff Lait on
  # roguelike.dev
  #
  # @todo have creatures stop chasing if they haven't had LoS on the player in
  # their last x turns
  #
  class AI
  
    # this is called each active phase
    def act(agent)
    end
    
  end
  
  # Basic melee (move towards player) AI.
  #
  class BasicMelee < AI
    
    def initialize
      @description = "Basic move towards player AI."
    end
    
    def act(agent)
      # set current location as target e.g. no move
      target_location = agent.location
      target_direction = nil
      
      agent.location.exits.each do |direction, location|
        if (location.walkable?) # better way?
          # if a surrounding location contains the player then just move there!
          if location.agent == GameWindow.instance.game.player
            target_location = location
            target_direction = direction
          # has the location been lit by the player?
          else (location.turn_last_lit != nil)
            # if location has been lit more recently set as target
            if (target_location.turn_last_lit < location.turn_last_lit)
              target_location = location
              target_direction = direction
            # location and target lit same turn
            elsif (target_location.turn_last_lit == location.turn_last_lit)
              # is the new location closer to the player?
              if (target_location.distance_to_player > location.distance_to_player)
                target_location = location
                target_direction = direction
              end
            end
          end
        end
      end
      # now move in the target direction
      agent.move(target_direction)
    end
  
  end
  
  # This is the same as BasicMelee except that if the creature has a ranged
  # attack in range of the player and LoS it fires that instead of moving. 
  #
  class BasicRanged < AI
    
    def initialize
      @description = "Basic ranged AI."
    end
    
    def act(agent)
       # set current location as target e.g. no move
       target_location = agent.location
       target_direction = nil

       if agent.ranged_attack != nil && agent.location.turn_last_lit == game.turn
         agent.fire(player)
       else
         agent.location.exits.each do |direction, location|
           if (location.walkable?) # better way?
             # if a surrounding location contains the player then just move there!
             if location.agent == player
               target_location = location
               target_direction = direction
               # has the location been lit by the player?
             else (location.turn_last_lit != nil)
               # if location has been lit more recently set as target
               if (target_location.turn_last_lit < location.turn_last_lit)
                 target_location = location
                 target_direction = direction
                 # location and target lit same turn
               elsif (target_location.turn_last_lit == location.turn_last_lit)
                 # is the new location closer to the player?
                 if (target_location.distance_to_player > location.distance_to_player)
                   target_location = location
                   target_direction = direction
                 end
               end
             end
           end
         end
         # now move in the target direction
         agent.move(target_direction)
       end 
     end
     
  end

end