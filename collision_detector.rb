module CollisionDetector
  module Posteriori    
    def detect_and_correct_collisions(objs)
      collision_happened = false
      for a in objs
        for b in objs
          collision_dist = a.radius + b.radius
          d = a.distance_to(b)
          if collision_dist > d && a != b
            collision_happened = true
            dx = a.x - b.x + 0.0
            dy = a.y - b.y + 0.0
            
            # Time delta from actual point of contact
            dt = (collision_dist - d) * d / ((b.xv*dx + b.yv*dy) - (a.xv*dx + a.yv*dy))
            
            # Move back to point of contact
            a.step!(-dt)
            b.step!(-dt)
                                    
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
            ed = 0.5
            vaP1 = va1 + (1 + ed) * (va2 - va1) / (1 + a.mass/b.mass)
            vaP2 = va2 + (1 + ed) * (va1 - va2) / (1 + b.mass/a.mass)
            
            # Undo projection
            a.xv = vaP1*ax - vb1*ay
      			a.yv = vaP1*ay + vb1*ax
      			b.xv = vaP2*ax - vb2*ay
      			b.yv = vaP2*ay + vb2*ax
      			      			
      			# Move forward in time
            a.step!(dt)
            b.step!(dt)      			
          end
        end
      end
      detect_and_correct_collisions(objs) if collision_happened
    end
  end
end