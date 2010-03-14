module CollisionDetector
  module JP
    def detect_and_correct_collisions(objs)
      collision_happened = false
      for a in objs
        for b in objs
          if a != b && collided?(a, b)
            collision_happened = true
            # now fix it
          end
        end
      end while collision_happened
    end
    
    def collided?(a, b):
      r_sum = a.radius + b.radius
      
      a_new = [a.x, a.y]
      a_old = [a.x - a.xv, a.y - a.yv]
      
      b_new = [b.x, b.y]
      b_old = [b.x - b.xv, b.y - b.yv]
      
      return intersection?(a_old, a_new, b_old, b_new) 
          || dist(a_new, b_new, b_old) < r_sum
          || dist(a_old, b_new, b_old) < r_sum
          || dist(b_new, a_new, a_old) < r_sum
          || dist(b_old, a_new, a_old) < r_sum
    end

    def intersection?(ao, an, bo, bn):
      denominator = (bn[1]-bo[1])*(an[0]-ao[0]) - (bn[0]-bo[0])*(an[1]-ao[1])
      
      u1=((bn[0]-bo[0])*(ao[1]-bo[1]) - (bn[1]-bo[1])*(ao[0]-bo[1]))/denominator
      return false if u1<0 || u1>1

      u2=((an[0]-ao[0])*(ao[1]-bo[1]) - (an[1]-ao[1])*(ao[0]-bo[1]))/denominator
      return u2 >= 0 && u2 <= 1
    end
    
    def dist(pt, start, finish)     
      r_numerator = (pt[0]-start[0])*(finish[0]-start[0]) +
                    (pt[1]-start[1])*(finish[1]-start[1])
      
      r_denomenator = (finish[0]-start[0])*(finish[0]-start[0]) +
                      (finish[1]-start[1])*(finish[1]-start[1])
      
      r = r_numerator / r_denomenator
      
      s = ((start[1]-pt[1])*(finish[0]-start[0])-(start[0]-pt[0])*(finish[1]-start[1]) ) / r_denomenator

      if (r >= 0) && (r <= 1)
          return Math.abs(s)*Math.sqrt(r_denomenator)
      else
          return [(pt[0]-start[0] )**2 + (pt[1]-start[1] )**2,
                  (pt[0]-finish[0])**2 + (pt[1]-finish[1])**2].min
      end
    end
    
  end
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
            
            #Will sez: try replacing the previous two blocks with a check if velocities are at all
            #in the direction of the collision (i.e., objects moving away from or tangentially to
            #each other aren't colliding)
            #since the "move back to point of contact" step will definitely break conservation of all sorts
            #of things, especially for rapidly-moving objects which intersect deeply. 
                                    
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
            
            #Will sez: previous three blocks are definitely redundant somehow
            #and this is where the "collision" happens, so should get factored out
                        
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