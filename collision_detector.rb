module CollisionDetector
  module Posteriori
    def detect_and_correct_collisions(objs)
      objs.each do |a|
        (objs - [a]).each do |b|
          collision_dist = a.radius + b.radius
          d = a.distance_to(b)
          if collision_dist > d
            puts "Current locations"
            puts "A: (#{a.x}, #{a.y})"
            puts "B: (#{b.x}, #{b.y})"
            dx = a.x - b.x + 0.0
            dy = a.y - b.y + 0.0
            
            # Our velocities relative to (dx, dy)
            va = (a.xv*dx + a.yv*dy) / d
            vb = (b.xv*dx + b.yv*dy) / d
            puts "Relative velocities"
            puts "#{va}, #{vb}"
            
            # Time delta from actual point of contact
            dt = (a.radius + b.radius - d) / (vb - va)
            puts "Time delta: #{dt}"
            
            # Move back to point of contact
            a.x -= a.xv * dt
            a.y -= a.yv * dt
            b.x -= b.xv * dt
            b.y -= b.yv * dt
            puts "Moving back in time"
            puts "A: (#{a.x}, #{a.y})"
            puts "B: (#{b.x}, #{b.y})"
                                    
            # Recalculate
            dx = b.x - a.x
            dy = b.y - a.y
            d = a.distance_to(b)
            puts "New distance: #{d}"
            
            # Unit vector in the direction of the collision
            ax = dx/d
            ay = dy/d
            puts "Unit vector: #{ax}, #{ay}"
            
            # Project velocities along unit vector
            va1 =  a.xv * ax + a.yv * ay
            vb1 = -a.xv * ay + a.yv * ax
            va2 =  b.xv * ax + b.yv * ay
            vb2 = -b.xv * ay + b.yv * ax
            
            # New velocities
            ed = 1.0
            vaP1 = va1 + (1 + ed) * (va2 - va1) / (1 + a.mass/b.mass)
            vaP2 = va2 + (1 + ed) * (va1 - va2) / (1 + b.mass/a.mass)
            
            # Undo projection
            a.xv = vaP1*ax - vb1*ay
      			a.yv = vaP1*ay + vb1*ax
      			b.xv = vaP2*ax - vb2*ay
      			b.yv = vaP2*ay + vb2*ax
      			
      			# Move forward in time
      			a.x += a.xv * dt
      			a.y += a.yv * dt
      			b.x += b.xv * dt
      			b.y += b.yv * dt
      			
      			puts "Correcting positions."
      			puts "A: (#{a.x}, #{a.y})"
            puts "B: (#{b.x}, #{b.y})"
            
            puts
          end
        end
      end
    end
  end
end