class Particle
  attr_accessor :x, :y, :xv, :yv
  
  def initialize(x_pos, y_pos, settings = {})
    @x = x_pos
    @y = y_pos
    @xv = settings[:x_speed] || 0
    @yv = settings[:y_speed] || 0
  end
  
  def distance_from(obj); distance_to(obj); end
  def distance_to(obj)
    Math.sqrt(squared_distance_to(obj))
  end
  
  def squared_distance_from(obj); squared_distance_to(obj); end
  def squared_distance_to(obj)
    ((x-obj.x)**2 + (y-obj.y)**2)
  end
  
  def step!(t = 1.0)
    @x += @xv * t
    @y += @yv * t
  end
  
  def increase_velocities_by(amt)
    reduce_velocities_by(-amt)
  end
  def reduce_velocities_by(amt)
    @xv *= (1-amt)
    @yv *= (1-amt)
  end
end