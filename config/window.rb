module Sanguine
  
  module Config
    TileWidth = 12
    TileHeight = 20
    ScreenWidth = 1200
    ScreenHeight = 700
    DefaultFont = 'JSL Ancient'  # 'Courier New' should work on most systems
    DefaultFontSize = 17
    Version = 0.5  # my completely arbitrary versioning system
  end
  
  module ZOrder
    MapObject = 0.0
    Location = 1.0
    Item = 2.0
    Agent = 3.0
    Player = 4.0
    Text = 5.0
  end
  
end