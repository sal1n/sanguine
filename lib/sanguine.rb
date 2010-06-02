begin
  # in case you use Gosu via RubyGems.
  require 'rubygems'
rescue LoadError
  # in case you don't.
end

require 'gosu'
require 'yaml'

path = File.dirname(__FILE__)

# load all configuration constants
Dir[path + '/../config/*.rb'].each {|file| require file }

require path + '/sanguine/handy_methods'
require path + '/sanguine/yaml_loader'
require path + '/sanguine/utility/utility'
require path + '/sanguine/utility/drawing'
require path + '/sanguine/utility/array_2d'
require path + '/sanguine/fov'
require path + '/sanguine/game_object'
require path + '/sanguine/effect'
require path + '/sanguine/effects'
require path + '/sanguine/map_object'

require path + '/sanguine/messages'
require path + '/sanguine/game'
require path + '/sanguine/map'
require path + '/sanguine/inventory'
require path + '/sanguine/equipment'
require path + '/sanguine/location'

require path + '/sanguine/ai'
require path + '/sanguine/agent'
require path + '/sanguine/player'
require path + '/sanguine/race'

require path + '/sanguine/creature'
require path + '/sanguine/creatures'
require path + '/sanguine/item'
require path + '/sanguine/items'
require path + '/sanguine/key'
require path + '/sanguine/utility/dice'
require path + '/sanguine/map_object'
require path + '/sanguine/game_window'
require path + '/sanguine/world'
require path + '/sanguine/profession'

require path + '/sanguine/states/state'
require path + '/sanguine/states/target'
require path + '/sanguine/views/view'

require path + '/sanguine/map_generation/ascii_map'
require path + '/sanguine/map_generation/bsp_node'

Dir[path + '/sanguine/states/*.rb'].each {|file| require file }
Dir[path + '/sanguine/views/*.rb'].each {|file| require file }
Dir[path + '/../data/maps/*.rb'].each {|file| require file }
Dir[path + '/../data/professions/*.rb'].each {|file| require file }

