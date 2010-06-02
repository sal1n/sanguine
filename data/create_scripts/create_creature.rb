require '../../lib/sanguine'

module Sanguine
  
  append = false
  
  if File.exists?("../creatures.yaml") && append
    # load creatures.yaml into an array of creature objects
    creatures = YAML.load(File.open("../creatures.yaml"))
  else
    creatures = Array.new
  end
  
  c = Creature.new
  c.name = "orc"
  c.description = "A large {green}green{black} humanoid, smarter and more fierce than the average goblin." 
  c.ai = BasicMelee.new
  c.exp = 10
  c.health = 30
  c.max_health = 30
  c.health_regen = 0.0
  c.mana = 0
  c.max_mana = 30
  c.mana_regen = 0.0
  c.speed = 1
  c.attack = 10
  c.defense = 10
  c.strikes = 1
  c.awareness = 1
  c.frequency = 1.0
  c.threat = 1
  c.min_level = 1
  c.max_level = 1
  c.colour = :red
  c.tile = 73
  c.resistances[:physical] = 0
  ca1 = CreatureAttack.new
  ca1.frequency = 1.0
  
  dh1 = DamageHealth.new("1d6 physical")
  dh1.message = "The orc hits you <health_dmg>"
  dh1.apply_on = :strike
  
  dh2 = DamageHealth.new("1d50 poison")
  dh2.name = "Mild Poison"
  dh2.apply_message = "You are poisoned!"
  dh2.message = "Ouch <health_dmg>"
  dh2.duration = "1d6"
  dh2.apply_on = :strike
  
  # add the effect to the creature attack
  ca1.effects.add(dh1)
  ca1.effects.add(dh2)
  # add the attack to the creature
  c.melee_attacks << ca1
  
  # add new creature to creatures array
  creatures << c
  
  # write creature array to file
  File.open("../creatures.yaml", "w") { |f| YAML.dump(creatures, f) } 
  
end