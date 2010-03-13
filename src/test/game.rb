class Game < Processing::App
  include CollisionDetector::Posteriori

  attr_accessor :comets, :wells

  def setup
    smooth
    @comets = [Mass.new(300,300,100), Mass.new(500,500,100, :y_speed => -1)]
    @wells = []
    ellipse_mode CENTER
    
    frame_rate 60
    @steps_per_frame = 2
    textFont createFont("FFScala", 16)
    
    background 0
  end
  
  def draw
    no_stroke
    
    fill 0, 0, 0, 16
    rect 0, 0, width, height

    fill 128, 0, 0
    no_stroke
    
    #detect_and_correct_collisions(@comets)
    
    @comets.each do |p|
      ellipse p.x, p.y, Math.sqrt(p.mass)/2, Math.sqrt(p.mass)/2
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
      ellipse w.x, w.y, 10, 10
    end
    
    @wells.reject! {|w| w.exp < Time.now }
    @comets.reject! {|p| p.x > width + 10 || p.x < -10 || p.y > height + 10 || p.y < -10 }
  end
  
  def mouse_dragged
    @wells << Well.new(mouse_x, mouse_y)
  end
  
  def key_pressed
    @comets << Mass.new(mouse_x, mouse_y, 100)
  end
  
end