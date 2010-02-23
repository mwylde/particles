require 'particle.rb'

class Display < Processing::App

  attr_accessor :particles, :wells

  def setup
    smooth
    @particles = [Particle.new(300,300,100), Particle.new(500,500,100,0,-1)]
    @wells = []
    @score = 0
    @playing = true
    ellipse_mode CENTER
    
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
    
    @particles.each do |p|
      ellipse p.x, p.y, Math.sqrt(p.mass)/2, Math.sqrt(p.mass)/2
      p.apply_gravity_from(@particles - [p] + @wells.map {|w|w.particle})
    end
    
    @particles.each {|p| p.step! }
    
    fill 0, 0, 128
    @wells.each do |w|
      ellipse w.particle.x, w.particle.y, 10, 10
    end
    
    @wells.reject! {|w| w.exp < Time.now }
    @particles.reject! {|p| p.x > width + 10 || p.x < -10 || p.y > height + 10 || p.y < -10 }
    
    @score +=  @particles.size - 1 if @playing
    
    unless @playing
      background 0
      text 'GAME OVER', 200, 200
      text @score, 200, 300
    end
    
    @playing = false if @particles.size == 0
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