class Well < Mass
  attr_accessor :exp
  def initialize(x, y)
    @exp = Time.now + 1
    super(x, y, 20)
  end
end