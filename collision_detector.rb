module CollisionDetector
  module Posteriori
    def detect_and_correct_collisions(objs)
      objs.each do |a|
        (objs - [a]).each do |b|
          
          collision_dist = a.radius + b.radius
          actual_dist = a.distance_to(b)
          if collision_dist > actual_dist
            dx = a.x - b.x
            dy = a.y - b.y
            
            # Our velocities relative to (dx, dy)
            va = (a.xv*dx + a.yv*dy) / actual_dist
            vb = (b.xv*dx + b.yv*dy) / actual_dist
            
            # Time delta
            dt = (a.radius + b.radius - actual_dist) / (va + vb)
            
            # Move back to point of contact
            a.x = a.x - a.xv * dt
            a.y = a.y - a.yv * dt
            b.x = b.x - b.xv * dt
            b.y = b.y - b.yv * dt
            
            # Recalculate
            dx = b.x - a.x
            dy = b.y - a.y
            d = a.distance_to(b)
            
            # Unit vector in the direction of the collision
            ax = dx/d
            ay = dy/d
            
            # Project velocities along unit vector
            va1 =  a.xv * ax + a.yv * ay
            vb1 = -a.xv * ay + a.yv * ax
            va2 =  b.xv * ax + b.yv * ay
            vb2 = -b.xv * ay + b.yv * ax
            
            # New velocities
            ed = 0.98
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
          end
        end
      end
    end
  end
end