module Sanguine
 
  module View
    
    class Equipment < View
      
      def initialize
        super(Point.new(330, 55))
        file = File.dirname(__FILE__) + "/../../../resources/background_menu.png"
        @background = Gosu::Image.new(window, file, false)
      end

      def tab
        @x = @x + 10
      end
      
      def tab_equipment
        @x = @x + 120
      end
      
      def tab_weight
        @x = @x + 500
      end
      
      def draw
        super
        
        # draw background
        # @todo scale this with window size
        @background.draw(280, 0, 0)
        
        window.write("Equipment",@x, @y)
        newline
        newline
        window.write("Press a key to inspect an item, press space to view inventory or press escape to return to map.", @x, @y)
        newline
        newline
        window.write("#{EquipmentSlot::Light}", @x, @y)
        tab
        window.write(")  light:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Light]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Head}", @x, @y)
        tab
        window.write(")  on head:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Head]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Neck}", @x, @y)
        tab
        window.write(")  around neck:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Neck]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::AroundBody}", @x, @y)
        tab
        window.write(")  around body:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::AroundBody]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Body}", @x, @y)
        tab
        window.write(")  on body:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Body]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Arms}", @x, @y)
        tab
        window.write(")  on arms:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Arms]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Hands}", @x, @y)
        tab
        window.write(")  on hands:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Hands]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::LeftRing}", @x, @y)
        tab
        window.write(")  left ring:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::LeftRing]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::RightRing}", @x, @y)
        tab
        window.write(")  right ring:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::RightRing]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Weapon}", @x, @y)
        tab
        window.write(")  wielding:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Weapon]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Shield}", @x, @y)
        tab
        window.write(")  shield:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Shield]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Legs}", @x, @y)
        tab
        window.write(")  on legs:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Legs]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Feet}", @x, @y)
        tab
        window.write(")  on feet:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Feet]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::RangedWeapon}", @x, @y)
        tab
        window.write(")  ranged weapon:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::RangedWeapon]}", @x, @y)
        newline
        window.write("#{EquipmentSlot::Ammunition}", @x, @y)
        tab
        window.write(")  ammunition:", @x, @y)
        tab_equipment
        window.write("#{player.equipment[EquipmentSlot::Ammunition]}", @x, @y)
        newline
        newline
        newline
        newline
        if game.state.inspect_item != nil
          item = game.state.inspect_item
          newline
          window.write("Inspect Item", @x, @y)
          newline
          window.write("#{item.name}", @x, @y)
          newline
          window.write("#{item.description}", @x, @y)
          newline
        end
      end
      
    end

  end
  
end