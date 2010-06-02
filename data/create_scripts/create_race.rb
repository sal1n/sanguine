require '../../lib/sanguine'

module Sanguine
  
  append = false
  
  if File.exists?("../races.yaml") && append
    # load races.yaml into an array of race objects
    races = YAML.load(File.open("../races.yaml"))
  else
    races = Array.new
  end

  r = Race.new
  r.name = "Human"
  r.description = "The base race."
  r.strength_dice = Dice.new("2d10 + 20")
  r.toughness_dice = Dice.new("2d10 + 20")
  r.agility_dice = Dice.new("2d10 + 20")
  r.intelligence_dice = Dice.new("2d10 + 20")
  r.willpower_dice = Dice.new("2d10 + 20")
  r.fellowship_dice = Dice.new("2d10 + 20")
  r.health_dice = Dice.new("2d10 + 20")
  r.health_regen = 0.0
  r.mana_dice = Dice.new("2d10 + 20")
  r.mana_regen = 0.0
  r.attack = 1
  r.defense = 1
  r.speed = 1
  r.strikes = 1
  r.stealth = 1
  
  # add new race to races array
  races << r
  
  # write weapons array to file
  File.open("../races.yaml", "w") { |f| YAML.dump(races, f) } 
  
end