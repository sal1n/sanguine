module Sanguine

  module State
  
    class Map < State
      
      def initialize
        super
       @views << View::Character.new
        @views << View::Map.new
        @views << View::Messages.new
      end
      
      def command(key)
        if key.is_direction?
          player.move(key.direction)
          game.advance_phase
        elsif key.symbol == :i
          game.change_state(ViewInventory.new)
        elsif key.symbol == :q
          game.change_state(Drink.new)
        elsif key.symbol == :d
          game.change_state(Drop.new)
        elsif key.symbol == :g
          game.change_state(Get.new)
        elsif key.symbol == :e
          game.change_state(Equip.new)
        elsif key.symbol == :t
          game.change_state(Unequip.new)
        elsif key.symbol == :x
          game.change_state(ViewEquipment.new)
        elsif key.symbol == :v
          game.change_state(Throw.new)
        elsif key.symbol == :f
          game.change_state(Fire.new)
        elsif key.symbol == :C
          game.change_state(Chat.new)
        elsif key.symbol == :l
          game.change_state(Look.new)
        elsif key.symbol == :u
          player.portal
          game.advance_phase
        elsif key.symbol == :escape
          game.save
          game.change_state(Menu.new)
        end
        
      end
      
    end
    
  end
  
end
