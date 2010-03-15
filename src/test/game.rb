class Game < Processing::App
  include CollisionDetector::Posteriori

  attr_accessor :comets, :wells, :scale
  
  MIN_SCALE = 1
  MAX_SCALE = 3
  MIN_MASS = 0
  MAX_MASS = 10000
  STAR_DENSITY = 0.0001 #the probability that a given pixel will be a star

  def setup
    smooth
    @comets = [Mass.new(300,300,100), Mass.new(500,500,100, :y_speed => -1)]
    @wells = []
    ellipse_mode CENTER
    
    @total_mass = find_total_mass
    @scale = 1
    
    frame_rate 60
    @steps_per_frame = 2
    textFont createFont("FFScala", 16)

    @stars = create_starfield
    background 0
  end
  
  def draw
    no_stroke
    
    @stars.each{|star|
      ellipse s_x(star[0]), s_y(star[1]), star[2]/@scale, star[2]/@scale
      fill star[3]
    }
    
    fill 0, 0, 0, 16
    rect 0, 0, width, height

    fill 128, 0, 0
    no_stroke
    
    #detect_and_correct_collisions(@comets)
    
    @comets.each do |p|
      ellipse s_x(p.x), s_y(p.y), Math.sqrt(p.mass)/(2*@scale), Math.sqrt(p.mass)/(2*@scale)
    end
    
    @steps_per_frame.times do
      @comets.each {|p| p.apply_gravity_from(@comets - [p] + @wells, 1.0/@steps_per_frame) }
      @comets.each do |p|
        p.step!
        p.reduce_velocities_by(0.001) # stabilizes systems slowly
      end
    end
        
    fill 0, 0, 128
    @wells.each do |w|
      ellipse s_x(w.x), s_y(w.y), 10/@scale, 10/@scale
    end
    
    
    @wells.reject! {|w| w.exp < Time.now }
    @comets.reject! {|p| s_x(p.x) > width + 10 || s_x(p.x) < -10 || s_y(p.y) > height + 10 || s_y(p.y) < -10 }

    @total_mass = find_total_mass
    @new_scale = find_scale
    if (@new_scale - @scale).abs > 0.001
      @scale += 0.001 * (@new_scale-@scale)/(@new_scale-@scale).abs
    end
  end
  
  def mouse_pressed
    mouse_dragged
  end  
  def mouse_dragged
    @wells << Well.new(i_x(mouse_x), i_y(mouse_y))
  end
  
  def key_pressed
    @comets << Mass.new(i_x(mouse_x), i_y(mouse_y), rand(200)+50)
  end
  
  private
  def create_starfield
  	stars = []
  	max_width = width * MAX_SCALE
  	max_height = height * MAX_SCALE
  	(max_width * max_height * STAR_DENSITY).to_i.times do |time|
  	  #[x, y, radius, brightness]
	    stars << [rand(max_width)-max_width/2, rand(max_height)-max_height/2, rand(3)+1, rand(50)+100]
	  end
	  stars
  end
  def s_x(x)
    #this is the expanded form of the calculation, included for clarity:
    #c = width/2.0
    #cs = c/@scale
    #min = c-cs
    #max = c+cs
    #(x/width) * (max-min) + min
    
    #this is the above simplified
    x/@scale+width/2.0*(1-1/@scale)
  end
  def s_y(y)
    y/@scale+height/2.0*(1-1/@scale)
  end
  
  def i_x(x)
    (x - width/2.0*(1-1/@scale))*@scale
  end
  def i_y(y)
    (y - height/2.0*(1-1/@scale))*@scale
  end
  
  def find_total_mass
    @comets.inject(0){|sum, comet| sum + comet.mass}
  end
  
  def find_scale
    mass = @total_mass
    mass = MIN_MASS if @total_mass < MIN_MASS
    mass = MAX_MASS if @total_mass > MAX_MASS
    
    (mass.to_f-MIN_MASS)/(MAX_MASS-MIN_MASS) * (MAX_SCALE-MIN_SCALE) + MIN_SCALE
  end
end