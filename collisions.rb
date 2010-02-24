require 'mass.rb'
require 'collision_detector.rb'

class Collisions < Processing::App
  include CollisionDetector::Posteriori

  attr_accessor :comets

  def setup
    smooth
    @comets = []
    25.times do
      @comets << Mass.new(rand(width), rand(height), 100, 
                  :radius => 10,
                  :x_speed => 2,
                  :y_speed => 3) 
    end
    # @comets = [
    #     Mass.new(width/2, height/2, 100, :radius => 10, :x_speed => -4),
    #     Mass.new(width/4, height/2, 100, :radius => 10, :x_speed => 0)
    #   ]
    ellipse_mode CENTER
    
    frame_rate 20
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
    end
    
    detect_and_correct_collisions(@comets)
    
    @comets.each do |p|
      ellipse p.x, p.y, p.radius*2, p.radius*2
    end 
  end
  
  def mouse_clicked
    setup
    #@comets << Mass.new(mouse_x, mouse_y, 100, :radius => 10, :x_speed => 3, :y_speed => 3)
  end
  
end

Collisions.new :title => "Spaced", :width => 1000, :height => 800