class Mass < Particle
  @@G = -0.15
  attr_accessor :mass, :radius
  
  def initialize(x, y, mss, settings = {})
    super(x, y, settings)
    @mass = mss
    @radius = settings[:radius] || 5
  end
  
  def apply_gravity_from(objs, timestep = 1.0)
    objs.each do |obj|
      dx = @x-obj.x
      dy = @y-obj.y
      
      d = [distance_to(obj), 20].max
              
      # Accel due to gravity = GM / d^2 = d / t^2
      # We want change in velocity, which is d/t
      # So multiply accel by t:
      #   GM / d^2 * t = GMt / d^2    unit: d/t
      # But we want the components of that velocity
      # So multiply by dx/d and dy/d:
      #   delta xv = GMt * dx / d^3
      #   delta yv = GMt * dy / d^3
      # Cache GMt / d^3:
      hertz = (obj.mass * timestep * @@G) / d**3
      
      @xv = @xv + hertz * dx
      @yv = @yv + hertz * dy
    end
  end
  
  def overlaps?(m)
    distance_to(m) < radius + m.radius
  end
end