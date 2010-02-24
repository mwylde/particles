require 'mass.rb'
require 'collision_detector.rb'

class Collisions < Processing::App
  include CollisionDetector::Posteriori

  attr_accessor :comets

  def setup
    smooth
    @comets = [Mass.new(width / 2, height / 2, 100, :radius => 20),
                Mass.new(3 * width / 4 ,10 +  height / 2 , 200, :radius => 20, :x_speed => -1)]
    ellipse_mode CENTER
    
    frame_rate 30
    textFont createFont("FFScala", 16)
  end
  
  def draw
    background 0
    fill 255, 0, 0
    
    no_stroke
    
    @comets.each {|p| p.step! }
    detect_and_correct_collisions(@comets)
    
    @comets.each do |p|
      ellipse p.x, p.y, p.radius*2, p.radius*2
    end 
  end
  
  def mouse_clicked
    setup
  end
  
end

Collisions.new :title => "Spaced", :width => 1000, :height => 800