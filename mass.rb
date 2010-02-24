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
      
      theta = Math.atan((dy/dx).abs)      
      
      @xv = @xv + acceleration * Math.cos(theta) * (0 <=> dx) # x<=>y is x == y ? 0 : (x > y ? 1 : -1)
      @yv = @yv + acceleration * Math.sin(theta) * (0 <=> dy) # so this is the oppposite sign of the argument
    end
  end
  
  def overlaps?(m)
    distance_to(m) < radius + m.radius
  end
end