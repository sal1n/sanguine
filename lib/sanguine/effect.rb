module Sanguine
  
  # An effect (along with GameObject) is the fundamental building block of the game.  
  # effects are applied on game objects and can affect them in whatever way 
  # desired.  For example a weapon doesn't have a damage variable - what it does have
  # is a DamageHealth effect which is applied on strike.
  # 
  # subclasses below into:
  # ModifyStat, DamageHealth, DamageMana etc
  #
  class Effect
  
    attr_accessor :name, :apply_message, :message
    attr_accessor :apply_on
    attr_accessor :radius
    attr_accessor :origin
    
    def active?
      @active
    end
    
    def activate(origin)
      @active = true
      @origin = origin
      # if duration is a dice then roll it and store the value
      @duration = self.duration
      @apply_on = :self
    end
    
    def duration
      @duration.kind_of?(Dice) ? @duration.roll : @duration.to_i
    end

    def duration=(value)
      @duration = Dice.new(value)
    end
    
    def has_name?
      ! @name.nil?
    end
    
    def has_message?
      ! @message.nil?
    end
    
    def has_radius?
      ! @radius.nil?
    end
    
  end 
  
  class ModifyStat < Effect
  
    attr_accessor :stat, :amount
    
    def initialize(stat, amount)
      super()
      @stat = stat
      @amount = amount
    end
    
    def activate(origin)
      super
      @amount = @amount.roll
    end
    
    def amount
      @amount.roll
    end
    
  end
  
  class Heal < Effect
    
    def initialize(amount)
      super()
      
      @amount = amount 
    end
    
    def amount
      @amount.roll
    end
    
  end
  
  class Recharge < Effect
     
     attr_accessor :dice
     
     def initialize(string)
       super()
       
       @dice = Dice.new(string)
     end
     
  end
  
  class Damage < Effect
    
    attr_accessor :type, :stat
    
    def initialize(string)
      super()
      
      # split the string which should be in the form "2d6 + 10 physical"
      string_array = string.split
      # type is the last element of the array
      @type = string_array.last 
      # remove type
      string_array.pop
      # the remainder is the dice
      @amount = Dice.new(string_array.join)
    end
    
    def amount
      @amount.roll
    end
    
    def min
      1
    end
    
    def max
      5
    end
    
    # class method.
    # returns coloured description of the damage for a given amount as per 
    # old school MUD's;)
    def self.description(amount)
      if (amount <= 10)
        'scratches'
      elsif (amount > 10 && amount <= 20)
        'grazes'
      elsif (amount > 20 && amount <= 30)
        'hits'
      elsif (amount > 30 && amount <= 40)
        'injures'
      elsif (amount > 40 && amount <= 50)
        'wounds'
      elsif (amount > 50 && amount <= 60)
        'mauls'
      elsif (amount > 60 && amount <= 70)
        'decimates'
      elsif (amount > 70 && amount <= 80)
        'devastates'
      elsif (amount > 80 && amount <= 90)
        'maims'
      elsif (amount > 90 && amount <= 100)
        'MUTILATES'
      elsif (amount > 100 && amount <= 110)
        'DISEMBOWELS'
      elsif (amount > 110 && amount <= 120)
        'DISMEMBERS'
      elsif (amount > 120 && amount <= 130)
        'MASSACRES'
      elsif (amount > 130 && amount <= 140)
        'MANGLES'
      elsif (amount > 140 && amount <= 150)
        '*** DEMOLISHES ***'
      elsif (amount > 150 && amount <= 160)
        '*** DEVASTATES ***'
      elsif (amount > 160 && amount <= 170)
        '=== OBLITERATES ==='
      elsif (amount > 170 && amount <= 180)
        '>>> ANNIHILATES <<<'
      elsif (amount > 180 && amount <= 190)
        '<<< ERADICATES >>>'
      elsif (amount > 190 && amount <= 200)
        'does GHASTLY things to'
      elsif (amount > 200 && amount <= 210)
        'does HORRID things to'
      elsif (amount > 210 && amount <= 220)
        'does DREADFUL things to'
      elsif (amount > 220 && amount <= 230)
        'does HIDEOUS things to'
      elsif (amount > 230)                    
        'does {red}{bU{rn{bS{rP{bE{rA{bK{ra{bb{rl{bE {wthings to'
      end
    end
    
  end
  
  class DamageHealth < Damage
  end
  
  class DamageMana < Damage
  end
  
end
