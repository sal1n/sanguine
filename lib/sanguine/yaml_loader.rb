require 'singleton'

module Sanguine

  # Loads YAML game data files.
  #
  class YamlLoader
    
    def self.creatures
      File.open(File.dirname(__FILE__) + "/../../data/creatures.yaml")
    end
    
    def self.races
      File.open(File.dirname(__FILE__) + "/../../data/races.yaml")
    end
    
    def self.weapons
      File.open(File.dirname(__FILE__) + "/../../data/weapons.yaml")
    end
    
    def self.ranged_weapons
    end
    
    def self.armour
    end
    
    def self.potions
    end
    
  end
  
end
