require 'observer' 

module Sanguine
  
  class Game

    include Observable
    
    attr_accessor :messages, :turn, :phase, :tick
    
    attr_accessor :state
    
    attr_accessor :races, :professions, :target
    
    attr_accessor :world, :map, :creatures, :items, :player
    
    attr_accessor :agents, :graveyard, :last

    attr_accessor :effects
    
    def initialize
  

      
      @agents = Array.new
      @graveyard = Array.new
      
      @messages = Messages.new
      @turn = 0 
      @tick = 0 #incremented each phase
      #ticks on normal and slow
      # tick   x00x0 
      # normal x00x0 60%
      # slow   xx0xx 20%
      # fast   000x0 80%
      # quick  00000 100%
      # slow normal fast quick
      @phases = Array[Speed::Fast, Speed::Normal, Speed::Slow, Speed::Quick, Speed::Normal]
      
      @phases.each do |phase|
        @messages.push(phase.to_s)
      end
      
      @phase = @phases[@tick % @phases.length]
      
      
      @t = 0
    end
    
    def change_state(state)
      @state = state
      @state.activate
    end
    
    
    def change_map(destination)
      @map = @world.change_map(destination)
      
      # populate frequency hashes
    end
    
    def load_data
      @races = YAML.load(YamlLoader.races)
      @weapons = YAML.load(YamlLoader.weapons)
      
      @professions = load_professions
      @world = World.new
      @world.load
      @items = Items.new
      @items.load
      @creatures = Creatures.new
      @creatures.load
    end
    
    attr_accessor :world
    
    # returns array of all loaded Professions
    def load_professions
      classes = ObjectSpace.enum_for(:each_object, class << Profession; self; end).to_a
      # remove the base class
      classes.delete(Profession)

      # we now need to instantiate each class
      professions = Array.new
      classes.each do |p|
        professions << p.new
      end
      professions
    end
    
    def get_random_creature
      @creatures.get_random
    end
    
    def get_potion
      @items.get_potion
    end
    
    def get_armour
      @items.get_armour
    end
    
    def set_level(min_level, max_level)
     # @items.set_level(level)
    #  @creatures.set_level(level)
    end
    
    def get_random_item
      @items.get_random
    end
    
    def save
      File.open("./saves/#{player.name}", "w") do |f|      
        f.puts(Marshal.dump(self))
      end
    end
    
    def get_nearest_agent(agent)      
      @agents.sort! { |a, b| a.location.distance_to_player <=> b.location.distance_to_player }
      @agents.first
    end
    
    
    def add_agent(agent)
      
      #self.add_observer(agent)
      @agents << agent
    end
    
    def remove_agent(agent)
      # delete the agent from the observer array
      self.delete_observer(agent)
      @agents.delete(agent)
      @graveyard << agent
    end
    
    def advance_phase
      # update FoV
      @map.clear_visible
      @map.do_fov(@player.x, @player.y, 12)
      
      # if active agents can act in this phase then act
      @agents.each do |agent|
        if agent.active? && agent.can_act?
          agent.act
        end
      end
    
      # increment the game ticks and determine the new phase
      @tick = @tick + 1
      @phase = @phases[@tick % @phases.length]
      
      # advance turn if phase is normal or slow
      if (@phase == Speed::Normal || @phase == Speed::Slow)
        advance_turn
      end

      # if player cannot act then just increment phase
      if(!@player.can_act?)
        advance_phase
      end
    end
    
    def advance_turn
      @turn = @turn + 1
      # notify observers that the turn has advanced
      changed 
      notify_observers
    end
    
  end
  
end