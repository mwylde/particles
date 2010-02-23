require 'mass.rb'

class Display < Processing::App

  attr_accessor :comets, :wells

  def setup
    smooth
    @comets = [Mass.new(300,300,100), Mass.new(500,500,100, :y_speed => -1)]
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
    
    @comets.each do |p|
      ellipse p.x, p.y, Math.sqrt(p.mass)/2, Math.sqrt(p.mass)/2
      p.apply_gravity_from(@comets - [p] + @wells.map {|w|w.mass})
    end
    
    @comets.each {|p| p.step! }
    
    fill 0, 0, 128
    @wells.each do |w|
      ellipse w.mass.x, w.mass.y, 10, 10
    end
    
    @wells.reject! {|w| w.exp < Time.now }
    @comets.reject! {|p| p.x > width + 10 || p.x < -10 || p.y > height + 10 || p.y < -10 }
    
    @score +=  @comets.size - 1 if @playing
    
    unless @playing
      background 0
      text 'GAME OVER', 200, 200
      text @score, 200, 300
    end
    
    @playing = false if @comets.size == 0
  end
  
  def mouse_pressed
    @wells << Well.new(mouse_x, mouse_y)
    @score -= 10
  end
  
  def key_pressed
    @comets << Mass.new(mouse_x, mouse_y, rand(200)+50)
    @score -= 1000
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