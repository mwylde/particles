require 'particle'

class Mass < Particle
  @@G = 0.5
  attr_accessor :mass, :radius
  
  def initialize(x, y, mss, settings = {})
    super(x, y, settings)
    @mass = mss
    @radius = settings[:radius] || 5
  end
  
  def apply_gravity_from(objs)
    objs.each do |obj|
      dx = @x-obj.x
      return if dx == 0
      dy = @y-obj.y
      sqrd = squared_distance_to(obj)
      
      if sqrd < 1000
        sqrd = 1000
      end
      
      acceleration = ((obj.mass * @@G) / sqrd)
            
      @xv = @xv + acceleration * -dx / Math.sqrt(sqrd) # x<=>y is x == y ? 0 : (x > y ? 1 : -1)
      @yv = @yv + acceleration * -dy / Math.sqrt(sqrd) # so this is the oppposite sign of the argument
    end
  end
  
  def overlaps?(m)
    distance_to(m) < radius + m.radius
  end
end