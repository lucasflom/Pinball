public class Circle {
    public Vec2 pos;
    public float r;
    public float mass;
    public Vec2 vel;
    
    public Circle(Vec2 pos, float r, float mass, Vec2 vel){
        this.pos = pos;
        this.r = r;
        this.mass = mass;
        this.vel = vel;
    }
    
    
   	// Circle v Circle
    public Boolean isColliding(Circle other) {
        float distance = this.pos.distanceTo(other.pos);
        return (distance < this.r + other.r);
    }
    
    // Circle v Line Segment
    public Boolean isColliding(Line line) {
        Vec2 closestPoint = new Vec2 (constrain(this.pos.x, line.l1.x, line.l2.x), constrain(this.pos.y, line.l1.y, line.l2.y));
        return (this.pos.distanceTo(closestPoint) < this.r);
    }

    // Circle v Box
    public Boolean isColliding(Box box) {
        Vec2 closestPoint = new Vec2 (constrain(this.pos.x, box.pos.x - box.w/2, box.pos.x + box.w/2), constrain(this.pos.y, box.pos.y - box.h/2, box.pos.y + box.h/2));
        return (this.pos.distanceTo(closestPoint) < this.r);
    }
}

public class Line {
    public Vec2 l1, l2;
    
    public Line(float x1, float y1, float x2, float y2){
        this.l1 = new Vec2(x1, y1);
        this.l2 = new Vec2(x2, y2);
    }
    
    // Inspiration for this came from lecture slides
    public Boolean sameSide(Line other) {
        float cp1 = cross(this.l2.minus(this.l1), other.l1.minus(this.l1));
        float cp2 = cross(this.l2.minus(this.l1), other.l2.minus(this.l1));
        return ((cp1 * cp2) >= 0); // Same sign, means they are on the same side of the line
    }
    
    // Line Segment v Line Segment
    public Boolean isColliding(Line other) {
        // Checks to see if either line crosses the other, checks both lines to be certain (***Could be moved to only one line?)
        if (this.sameSide(other)) return false;
        if (other.sameSide(this)) return false;
        return true;
    }

  // Line Segment v Box
  // This is modeled after the suggestion from lecture
    public Boolean isColliding(Box box) {
        // Check if line is inside the box by checking if end points of line are inside the box (***Checking first cause it could save some time as it should be easier)
        // Check start point
        if ((this.l1.x >= (box.pos.x - box.w/2)) && (this.l1.x <= (box.pos.x + box.w/2)) && (this.l1.y >= (box.pos.y - box.h/2)) && (this.l1.y <= (box.pos.y + box.h/2))) return true;
        // Check end point
        if ((this.l2.x >= (box.pos.x - box.w/2)) && (this.l2.x <= (box.pos.x + box.w/2)) && (this.l2.y >= (box.pos.y - box.h/2)) && (this.l2.y <= (box.pos.y + box.h/2))) return true;
        // Check if the line intersects any of the boxes lines. If there is an intersection(both of the points aren't on the same side) then returns true
        Line b1 = new Line(box.pos.x - box.w/2, box.pos.y + box.h/2, box.pos.x + box.w/2, box.pos.y + box.h/2);
        Line b2 = new Line(box.pos.x - box.w/2, box.pos.y - box.h/2, box.pos.x + box.w/2, box.pos.y - box.h/2);
        Line b3 = new Line(box.pos.x - box.w/2, box.pos.y + box.h/2, box.pos.x - box.w/2, box.pos.y - box.h/2);
        Line b4 = new Line(box.pos.x + box.w/2, box.pos.y + box.h/2, box.pos.x + box.w/2, box.pos.y - box.h/2);
        if (this.isColliding(b1)) return true; 
        if (this.isColliding(b2)) return true;
        if (this.isColliding(b3)) return true;
        if (this.isColliding(b4)) return true;
        
        return false;
    }
}

public class Box {
    public Vec2 pos;
    public float h, w;
    
    public Box(float x, float y, float w, float h){
        pos = new Vec2(x,y);
        this.w = w;
        this.h = h;
    }
    
    // Box v Box
    public Boolean isColliding(Box other) {
        // Is this box above or below the other?
        //     This bottom   is greater than other top             or       this top      is lower than   other bottom
        if (((this.pos.y - this.h/2) > (other.pos.y + other.h/2)) || ((this.pos.y + this.h/2) < (other.pos.y - other.h/2))) return false;
        // Is this box to the left or right of the other?
        if (((this.pos.x - this.w/2) > (other.pos.x + other.w/2)) || ((this.pos.x + this.w/2) < (other.pos.x - other.w/2))) return false;
        // If no then this box must be colliding
        return true;
    }
    
}
