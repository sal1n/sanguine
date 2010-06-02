module Sanguine
  
  module Duration
    Permanent = -1
    Instant = 0
  end
  
  module Speed
    Slow = 0
    Normal = 1
    Fast = 2
    Quick = 3
  end
  
  module MapGeneration
    SmallestPartitionSize = 12
    MaxPartitionSizeRatio = 1.5
    HomogeneityFactor = 0.25
  end
  
  module EquipmentSlot
    Light = :a
    Head = :b
    Neck = :c
    AroundBody = :d
    Body = :e
    Arms = :f
    Hands = :g
    LeftRing = :h
    RightRing = :i
    Weapon = :j
    Shield = :k
    Legs = :l
    Feet = :m
    RangedWeapon = :n
    Ammunition = :o
  end
  
end