require '../../lib/sanguine'

module Sanguine
  
  append = true
  
  if File.exists?("../weapons.yaml") && append
    # load weapons.yaml into an array of weapon objects
    weapons = YAML.load(File.open("../weapons.yaml"))
  else
    weapons = Array.new
  end

  w = Weapon.new
  w.name = "dagger"
  w.unknown_name = "dagger"
  w.description = "A basic dagger"
  w.tile = 480
  w.weight = 5
  w.value = 10
  w.slot = EquipmentSlot::Weapon
  w.frequency = 1.0
  w.min_level = 1
  w.max_level = 1
  
  dh1 = DamageHealth.new("1d6 physical")
  dh1.message = "Your slash <dmg_desc> <agent> <health_dmg> <mana_dmg>"
  dh1.apply_on = :strike
  
  dh2 = ModifyStat.new(:attack, Dice.new("20"))
  dh2.apply_on = :self
  
  w.effects.add(dh1)
  w.effects.add(dh2)
  
  # add new weapon to weapons array
  weapons << w
  
  # write weapons array to file
  File.open("../weapons.yaml", "w") { |f| YAML.dump(weapons, f) } 
  
end
