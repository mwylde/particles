class Well
  attr_accessor :mass, :exp
  def initialize(x, y)
    @exp = Time.now + 5
    @mass = Mass.new(x, y, 100)
  end
end