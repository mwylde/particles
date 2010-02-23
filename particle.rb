class Particle
  attr_accessor :x, :y, :xv, :yv
  
  def initialize(x_pos, y_pos, settings = {})
    @x = x_pos
    @y = y_pos
    @xv = settings[:x_speed] || 0
    @yv = settings[:y_speed] || 0
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