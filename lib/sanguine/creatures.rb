module Sanguine

  # Collection of all game creatures with methods to randomly select using a
  # frequency hash based on creature frequency.
  #
  class Creatures

    # constructor
    def initialize
      # all creatures stored in this array
      @creatures = Array.new
      # this hash is used for selecting random creatures
      @frequency_hash = Hash.new
    end
    
    # load all creature definitions from the YAML file
    def load
      @creatures = YAML.load(YamlLoader.creatures)
    end
    
    # populates a frequency hash for a given mix & max 
    def populate_frequency_hash(min_threat, max_threat)
      @creatures.each do |creature|
        if creature.threat >= min_threat && creature.threat <= max_threat
          @frequency_hash[creature] = creature.frequency
        end
      end
      # hash must be normalised for get_random to work
      Utility.normalise_frequency_hash!(@frequency_hash)
    end
  	
  	# gets random creature from the normalised hash weighted by creatures
    # frequency
  	def get_random
  	  target = rand
  	  @frequency_hash.each do |item, weight|
  	    return item.spawn if target <= weight
  	    target -= weight
  	  end
  	end
	  
  end

end