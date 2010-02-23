class Particle
  attr_accessor :x, :y, :mass, :xv, :yv
  
  def initialize(x_pos, y_pos, mss, x_vel = 0, y_vel = 0)
    @x = x_pos
    @y = y_pos
    @mass = mss
    @xv = x_vel
    @yv = y_vel
  end
  
  def apply_gravity_from(objs)
    g = 1.0
    
    objs.each do |obj|
      dx = @x-obj.x
      return if dx == 0
      dy = @y-obj.y
      sqrd = squared_distance_to(obj)
      
      if sqrd < 1000
        sqrd = 1000
      end
      
      acceleration = ((obj.mass * g) / sqrd)
      
      theta = Math.atan((dy/dx).abs)      
      
      @xv = @xv + acceleration * Math.cos(theta) * (0 <=> dx)
      @yv = @yv + acceleration * Math.sin(theta) * (0 <=> dy)
    end
  end
  
  def squared_distance_from(obj)
    squared_distance_to(obj)
  end
  def squared_distance_to(obj)
    ((x-obj.x)**2 + (y-obj.y)**2)
  end
  
  def step!
    @x += @xv
    @y += @yv
  end
end