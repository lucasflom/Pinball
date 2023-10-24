public class Circle {
    public Vec2 pos;
    public float r;
    public float mass;
    public Vec2 vel;

    public Circle(Vec2 pos, float r){
        this.pos = pos;
        this.r = r;
        this.mass = 9999;
        this.vel = new Vec2(0,0);
    }
    
    public Circle(Vec2 pos, float r, float mass, Vec2 vel){
        this.pos = pos;
        this.r = r;
        this.mass = mass;
        this.vel = vel;
    }
    

    // Circle v Point
    public Boolean isColliding(Vec2 point){
        float distance = this.pos.distanceTo(point);
        return (distance <= this.r);
    }
    
   	// Circle v Circle
    public Boolean isColliding(Circle other) {
        float distance = this.pos.distanceTo(other.pos);
        return (distance < this.r + other.r);
    }
    
    // Circle v Line Segment
    public Boolean isColliding(Line line) {
        // if ((line.l1.distanceTo(this.pos)) <= this.r || line.l2.distanceTo(this.pos <= this.r)){
        //     return true;
        // }
        Vec2 closestPoint = this.closestPoint(line);
        return (this.pos.distanceTo(closestPoint) < this.r);
    }

    // Returns the closest point between the circle and a line
    public Vec2 closestPoint(Line line) {
        float len = line.l1.minus(line.l2).length();
        float dot = (((this.pos.x-line.l1.x)*(line.l2.x-line.l1.x)) + ((this.pos.y-line.l1.y)*(line.l2.y-line.l1.y))) / pow(len, 2);
        Vec2 closest = new Vec2(line.l1.x + (dot *(line.l2.x-line.l1.x)), (line.l1.y + (dot * (line.l2.y - line.l1.y))));
        if (line.isColliding(closest)) return closest;
        // There is no point on the line that is closest so return whichever end point is closest
        if (line.l1.distanceTo(this.pos) < line.l2.distanceTo(this.pos)) return line.l1;
        return line.l2;
    }

    // Circle v Box
    // public Boolean isColliding(Box box) {
    //     Vec2 closestPoint = new Vec2 (constrain(this.pos.x, box.pos.x - box.w/2, box.pos.x + box.w/2), constrain(this.pos.y, box.pos.y - box.h/2, box.pos.y + box.h/2));
    //     return (this.pos.distanceTo(closestPoint) < this.r);
    // }
    public Boolean isColliding(Box box) {
        // Check if circle center is inside the box
        // Check start point
        if (box.isColliding(this.pos)) return true;
        // Check if the circle intersects any of the boxes lines
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

    // Returns the closest point between the circle and a box (Probably should be better and is causing the sliding motion)
    public Vec2 closestPoint(Box box) {
        return new Vec2 (constrain(this.pos.x, box.pos.x - box.w/2, box.pos.x + box.w/2), constrain(this.pos.y, box.pos.y - box.h/2, box.pos.y + box.h/2));
    }
}

public class Line {
    public Vec2 l1, l2;
    public float length, angle;
    
    public Line(float x1, float y1, float x2, float y2){
        this.l1 = new Vec2(x1, y1);
        this.l2 = new Vec2(x2, y2);
        this.length = this.l1.distanceTo(this.l2);
        this.angle = atan((max(y1, y2) - min(y1, y2)) / (max(x1, x2) - min(x1, x2)));
    }
    
    // Inspiration for this came from lecture slides
    public Boolean sameSide(Line other) {
        float cp1 = cross(this.l2.minus(this.l1), other.l1.minus(this.l1));
        float cp2 = cross(this.l2.minus(this.l1), other.l2.minus(this.l1));
        return ((cp1 * cp2) >= 0); // Same sign, means they are on the same side of the line
    }

    // Line v Point
    public Boolean isColliding(Vec2 point){
        float d1 = this.l1.distanceTo(point);
        float d2 = this.l2.distanceTo(point);
        // Buffer added for accuracy of floats
        float buffer = 0.1;
        if (d1+d2 >= this.length-buffer && d1+d2 <= this.length+buffer) return true;
        return false;
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

    // Box v Point
    public Boolean isColliding(Vec2 point) {
        if (point.x >= this.pos.x - this.w/2 && point.x <= this.pos.x + this.w/2 && point.y >= this.pos.y - this.h/2 && point.y <= this.pos.y + this.h/2) return true;
        return false;
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

public class Flipper extends Line {
  public float angular_vel;

  public Flipper(float x1, float y1, float x2, float y2) {
    super(x1, y1, x2, y2);
    this.angular_vel = 0;
  }
}
