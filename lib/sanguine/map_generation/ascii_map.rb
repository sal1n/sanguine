module Sanguine
  
  module MapGeneration
    
    class AsciiLocation

      attr_accessor :x, :y, :char

      def initialize(x, y, char)
        @x, @y, @char = x, y, char
      end

      def to_s
        @char
      end

    end

    class AsciiMap < Array2D

      def initialize(width, height)
        super

        self.fill_walls
      end

      def fill_walls
        self.width.times do |i|
          self.height.times do |j|
            self[i, j] = AsciiLocation.new(i, j,'#')
          end
        end
      end

      # need to stop rooms creating past borders, for now just fix them
      def fix_borders
        self.width.times do |i|
          self[i, 0] = AsciiLocation.new(i, 0, '#')
          self[i, self.height - 1] = AsciiLocation.new(i, self.height - 1, '#')
        end
        
        self.height.times do |j|
          self[0, j] = AsciiLocation.new(0, j, '#')
          self[self.width - 1, j] = AsciiLocation.new(self.width - 1, j, '#')
        end
      end
      
      def create_corridor(node)
         # child nodes were split along the horizontal axis so draw a horizontal corridor between them
         if node.split_orientation == :horizontal
           left_exit = room_exit(node.left, :horizontal, :left)
           right_exit = room_exit(node.right, :horizontal, :right)
           dig(left_exit, right_exit)
         else  # :vertical
           left_exit = room_exit(node.left, :vertical, :left)
           right_exit = room_exit(node.right, :vertical, :right)
          dig(left_exit, right_exit)
         end
      end

      def euclidean_distance(l1, l2)
        x = l2.x - l1.x
        x = x * x

        y = l2.y - l1.y
        y = y * y

        Math.sqrt(x + y) 
      end

      # dig a corridor between two locations
      def dig(location, target)

        if location == target
          return
        else
          location.char = '.'
        end

        possible_paths = Array.new
        possible_paths << self[location.x, location.y - 1]
        possible_paths << self[location.x + 1, location.y]
        possible_paths << self[location.x, location.y + 1]
        possible_paths << self[location.x - 1, location.y]

        path = possible_paths.first
        possible_paths.each do |p|
          if euclidean_distance(p, target) < euclidean_distance(path, target)
            path = p
          end
        end

        dig(path, target)

      end

      # really i should just keep track of the room boundaries with the nodes instead of
      # reverse calculating the bloody things
      def room_exit(node, split, side)
        # first we need to get all locations in the partition space
        partition_locations = Array.new

        node.width.times do |i|
          node.height.times do |j|
            location = self[i + node.x, j + node.y]
            if location.char == '.'
              partition_locations << location
            end
          end
        end

        if split == :horizontal
          # now we need to work out the right border of the room
          if side == :left
            x = node.x
          else
            x = node.x + node.width
          end
          partition_locations.each do |l|
            if side == :left
              if l.x > x
                x = l.x
              end
            else
              if l.x < x
                x = l.x
              end
            end
          end
          # select on the right border
          possible_exits = partition_locations.select { |l| l.x == x }
          # return a random location on the right border of the room
          possible_exits[rand(possible_exits.length)]
        else  # :vertical
          # now we need to work out the bottom border of the room
          if side == :left
            y = node.y
          else
            y = node.y + node.height
          end
          partition_locations.each do |l|
            if side == :left
              if l.y > y
                y = l.y
              end
            else
              if l.y < y
                y = l.y
              end
            end
          end
          # select on the bottom border
          possible_exits = partition_locations.select { |l| l.y == y }
          # return a random location on the bottom border of the room
         e =  possible_exits[rand(possible_exits.length)]
        end

      end

      def create_room(node)
        width = rand(node.width)
        if width < 5
          width = 5
        end

        height = rand(node.height)
        if height < 5
          height = 5
        end

        x  = node.x + (rand(node.width - width))
        if x == 0
          x = 1
        end

        y  = node.y + (rand(node.height - height))
        if y == 0
          y = 1
        end

        width.times do |i|
          height.times do |j|
            self[x + i, y + j] = AsciiLocation.new(x + i, y + j, '.')
          end
        end
      end

      def to_s
        s = ""
        self.height.times do |j|
          self.width.times do |i|
            s += self[i, j].to_s
          end
          if j < self.height - 1 # don't output the final \n
            s += "\n"
          end
        end
        s
      end
    end
    
  end
  
end
