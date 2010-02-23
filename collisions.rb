require 'mass.rb'

class Display < Processing::App

  attr_accessor :comets

  def setup
    smooth
    @comets = [Mass.new(width / 2, height /2, 100), Mass.new(width / 4, height / 2, 100, :x_speed => 2)]
    ellipse_mode CENTER
    
    frame_rate 60
    textFont createFont("FFScala", 16)
    
    background 0
  end
  
  def draw
    background 0
    
    no_stroke
    
    @particles.each do |p|
      ellipse p.x, p.y, 10, 10
      p.apply_gravity_from(@particles - [p] + @wells.map {|w|w.particle})
    end
    
    @particles.each {|p| p.step! }
  end
  
  def mouse_pressed
    @wells << Well.new(mouse_x, mouse_y)
    @score -= 10
  end
  
  def key_pressed
    @particles << Particle.new(mouse_x, mouse_y, rand(200)+50)
    @score -= 1000
  end
  
end

class Well
  attr_accessor :particle, :exp
  def initialize(x,y)
    @exp = Time.now + 5
    @particle = Particle.new(x,y, 100)
  end
end

Display.new :title => "Spaced", :width => 1000, :height => 800