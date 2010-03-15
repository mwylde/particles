require 'mass.rb'
require 'collision_detector.rb'

class Collisions < Processing::App
  include CollisionDetector::Posteriori

  attr_accessor :comets

  def setup
    smooth
    @comets = []
    @drag = nil
    
    [[100,100],[122,100],[144,100],[166,100],
     [111,120],[132,120],[153,120],[122,140],[144,140],[133,160]].each do |x,y|
          @comets << Mass.new(x,y,100,:radius => 10)
        end
        #@comets << Mass.new(130, 400, 100, :radius => 10, :y_speed => -4)
    
    # 1.upto(30) do |i|
    #      @comets << Mass.new(100 + (22*i), width/2, 100, :radius => 10)
    #    end
    #    @comets << Mass.new(1, width/2, 100, :radius => 10, :x_speed => 5)
    #    
    # 55.times do
    #   @comets << Mass.new(rand(width), rand(height), 100, 
    #               :radius => 10,
    #               :x_speed => 2,
    #               :y_speed => 3) 
    # end
    # @comets = [
    #     Mass.new(width/2, height/2, 100, :radius => 10, :x_speed => -4),
    #     Mass.new(width/4, height/2, 100, :radius => 10, :x_speed => 0)
    #   ]
    ellipse_mode CENTER
    
    frame_rate 30
    textFont createFont("FFScala", 16)
  end
  
  def draw
    background 0
    fill 255, 0, 0
    
    no_stroke
    
    @comets.each do |p|
      p.step!
      if p.x <= 0 || p.x >= width
        p.xv *= -1
        p.x = [[1.0, p.x].max, width-1.0].min
      end
      if p.y <= 0 || p.y >= height
        p.yv *= -1 
        p.y = [[1.0, p.y].max, height-1.0].min
      end
      p.reduce_velocities_by(0.01)
    end
    
    detect_and_correct_collisions(@comets)
    
    @comets.each do |p|
      ellipse p.x, p.y, p.radius*2, p.radius*2
    end
    
    unless @drag == nil
      fill 120, 0, 0
      stroke 120, 0, 0
      ellipse @drag.x, @drag.y, @drag.radius*2, @drag.radius*2
      line @drag.x, @drag.y, mouse_x, mouse_y
    end
  end
  
  def mouse_pressed
    @drag = Mass.new(mouse_x, mouse_y, 100, :radius => 10)
  end
  
  def mouse_released
    @drag.xv = (mouse_x - @drag.x)/10
    @drag.yv = (mouse_y - @drag.y)/10
    @comets << @drag
    @drag = nil
  end
  
  def key_pressed
    setup
    #@comets << Mass.new(mouse_x, mouse_y, 100, :radius => 10, :x_speed => 3, :y_speed => 3)
  end
  
end

Collisions.new :title => "Spaced", :width => 400, :height => 400