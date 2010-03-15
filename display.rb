require 'mass.rb'
require 'collision_detector.rb'


class Display < Processing::App
  include CollisionDetector::Posteriori

  attr_accessor :comets, :wells, :scale
  
  MIN_SCALE = 1
  MAX_SCALE = 3
  MIN_MASS = 0
  MAX_MASS = 10000

  def setup
    puts "Setting up"
    smooth
    @comets = [Mass.new(300,300,100), Mass.new(500,500,100, :y_speed => -1)]
    @wells = []
    @score = 0
    @playing = true
    ellipse_mode CENTER
    
    @total_mass = find_total_mass
    @scale = 1
    
    frame_rate 60
    textFont createFont("FFScala", 16)
    
    background 0
  end
  
  def draw
    no_stroke
    
    fill 0, 0, 0, 16
    rect 0, 0, width, height
    
    fill 0
    rect 10, 8, 40, 20

    stroke 128, 0, 0
    fill 128, 0, 0
    text @score, 10, 20
    no_stroke
    
    #detect_and_correct_collisions(@comets)
    
    @comets.each do |p|
      ellipse s_x(p.x), s_y(p.y), Math.sqrt(p.mass)/(2*@scale), Math.sqrt(p.mass)/(2*@scale)
      p.apply_gravity_from(@comets - [p] + @wells.map {|w|w.mass})
    end
    
    @comets.each {|p| p.step! }
        
    fill 0, 0, 128
    @wells.each do |w|
      ellipse s_x(w.mass.x), s_y(w.mass.y), 10/@scale, 10/@scale
    end
    
    @wells.reject! {|w| w.exp < Time.now }
    @comets.reject! {|p| s_x(p.x) > width + 10 || s_x(p.x) < -10 || s_y(p.y) > height + 10 || s_y(p.y) < -10 }
    
    @score +=  @comets.size - 1 if @playing
    
    unless @playing
      background 0
      text 'GAME OVER', 200, 200
      text @score, 200, 300
    end
    
    @playing = false if @comets.size == 0
    @total_mass = find_total_mass
    @new_scale = find_scale
    if (@new_scale - @scale).abs > 0.001
      @scale += 0.001 * (@new_scale-@scale)/(@new_scale-@scale).abs
    end
  end
  
  def mouse_pressed
    @wells << Well.new(i_x(mouse_x), i_y(mouse_y))
    @score -= 10
  end
  
  def key_pressed
    @comets << Mass.new(i_x(mouse_x), i_y(mouse_y), rand(200)+50)
    @score -= 1000
  end
  
  private
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

class Well
  attr_accessor :mass, :exp
  def initialize(x, y)
    @exp = Time.now + 5
    @mass = Mass.new(x, y, 100)
  end
end

Display.new :title => "Spaced", :width => 1000, :height => 800