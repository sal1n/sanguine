# Copyright (c) 2010 Steve Andrews <sanguine[at]salin[dot]org>
# All files in this distribution are subject to the terms of the Ruby license.

require './lib/sanguine'
require 'yaml'

module Sanguine

  window = GameWindow.instance
  
  game = Game.new
  
  window.game = game
    
  game.change_state(State::Splash.new)
  game.load_data
  
  game.map = game.world.maps[0]
  game.creatures.populate_frequency_hash(1,1)
  game.items.populate_weighted_hash(1)
  
  # thunderbirds are go!
  window.show

end