module Sanguine
  
  # collection of all game items with methods to randomly
  # select using a weighted hash based on item frequency
  class Items
  
    def initialize
      @items = Array.new
      @weighted_hash = Hash.new
    end
    
    # loads all item definitions via the YamlLoader
    def load
      
      @weapons = YAML.load(YamlLoader.weapons)
      
     # @ranged_weapons = DataLoader.instance.load_ranged_weapons
    #  @ammunition = DataLoader.instance.load_ammunition
     # @potions = DataLoader.instance.load_potions
      
      @items.concat(@weapons)
      #@items.concat(@ranged_weapons)
      #@items.concat(@ammunition)
      #@items.concat(@potions)
    end
    
    def get_item_by_name(name)
      @items.each do |item|
        if item.name == name
          return item
        end
      end
      nil
    end
    
    def get_potion
    w = @potions[0].clone
    w.effects = @potions[0].effects.clone
    w
    end
    
    def get_armour
      @ammunition[0].clone
    end
    
    
    def populate_weighted_hash(min_level)
      @items.each do |item|
        if item.min_level >= min_level
          @weighted_hash[item] = item.frequency
        end
      end
      self.normalize!
    end
    
    # normalise the frequencies so they add up to 1 (within the limits of floating-
    # point arithmetic)
    def normalize!
  	  sum = @weighted_hash.inject(0) do |sum, item|
  	    sum += item[1]
  	  end
  	  sum = sum.to_f
  	  @weighted_hash.each { |item, frequency| @weighted_hash[item] = frequency / sum }
  	end
  	
  	# gets random creature from the normalised hash weighted by creatures frequency
  	# note - hash must be normalised first for this to work!
  	def get_random
  	  target = rand
  	  @weighted_hash.each do |item, frequency|
  	    if target <= frequency
  	      random_item = item.clone
  	      random_item.effects = item.effects.clone
  	      return random_item
	      else
	        target -= frequency
        end
  	  end
  	end
  	
  end

end
  
  