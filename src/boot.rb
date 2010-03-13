def require_files(files)
  dir = File.dirname(__FILE__)
  files.each do |file|
    if file =~ /\*\.rb/
      Dir[dir + file].each {|f| require f }
    else
      require File.join(dir, file)
    end
  end
end

require_files ['/game/*.rb', '/graphics/*.rb', '/physics/particle', '/physics/*.rb', '/test/*.rb']

case ARGV[0].strip
  when 'game'     then Game.new :title => "Critical Mass", :width => 1000, :height => 800
  when 'sandbox'  then Sandbox.new :title => "Sandbox", :width => 400, :height => 400
end