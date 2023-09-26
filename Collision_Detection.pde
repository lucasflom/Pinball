

// Set the desired file to be run

String taskNum = "10";

String fname = "task" + taskNum + ".txt";

IntList collisions = new IntList();

PrintWriter output;

int circNum;
Circle circList[];

int lineNum;
Line lineList[];

int boxNum;
Box boxList[];

void setup() {
    // Setup the default screen
	size(1000, 1000);
	output = createWriter("task"+taskNum+"_solution.txt");
	int boxbox = 0;
	int circlesHere = 0;
	// Read the file and update totals from above
	String[] lines = loadStrings(fname);
	circNum = int(lines[0].substring(9));
	lineNum = int(lines[circNum+2].substring(7));
	boxNum = int(lines[circNum+2+lineNum+2].substring(7));
	//println("Working on Circles List");
	circList = new Circle[circNum];
	for (int i = 2; i < (circNum+2); i++){
    	String[] data = lines[i].split(" ");
        circList[i-2] = new Circle(float(data[2]), float(data[3]), float(data[4]));
	}
	//println("Working on Lines List");
	lineList = new Line[lineNum];
	for (int i = (circNum + 4); i < (circNum+lineNum+4); i++) {
		String[] data = lines[i].split(" ");
		lineList[i-(circNum+4)] = new Line(float(data[2]), float(data[3]), float(data[4]), float(data[5]));
	}
	//println("Working on Boxes List");
	boxList = new Box[boxNum];
	for (int i = (circNum + lineNum + 6); i < (circNum+lineNum+boxNum+6); i++) {
		String[] data = lines[i].split(" ");
		boxList[i-(circNum+lineNum+6)] = new Box(float(data[2]), float(data[3]), float(data[4]), float(data[5]));
	}
	int startTime = millis();
	//println("Checking for circle v shape collision");
	for (int i = 0; i < circNum; i++){
    	// Check against all other circles
    	for (int j = (i + 1); j < circNum; j++){ // circle-circle
        	if (circList[i].isColliding(circList[j])){
            	// Need to check to make sure that it isn't in the list to avoid duplicates instead of removing them at the end ***Could remove at the end and might save time
            	//println("Collision between " + str(i) + " and " + str(i));
            	boolean alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == i){
                        alreadyIn = true;
                        break;    
                    }
                } if (!alreadyIn) {collisions.append(i); circlesHere++;}
            	// Time to check if the other circle is already in the list
            	alreadyIn = false;
            	for (int k = 0; k < collisions.size(); k++){
            		if (collisions.get(k) == j){
                		alreadyIn = true;
                		break;	
            		}
            	} if (!alreadyIn) {collisions.append(j); circlesHere++;}
    		}
    	}
    	// Check against all the lines
    	for (int j = 0; j < lineNum; j++){ // circle-line
        	if (circList[i].isColliding(lineList[j])){
            	//println("Collision between " + str(i) + " and " + str(j+circNum));
            	boolean alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){  // Whenver final ID's are used for anything besides circle the previous shapes total has to be appended
                    if (collisions.get(k) == (i)){			  // Which is the case when we are using others but this case is for circle
                        alreadyIn = true;
                        break;    
                    }
                } if (!alreadyIn) {collisions.append(i); circlesHere++;}
  				// Time to check if the line is already in
            	alreadyIn = false; // *** Could optimize by having it sorted already and then skipping the circles because wouldn't be a circle
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == (j + circNum)){
                        alreadyIn = true;
                        break;    
                    }
                } if (!alreadyIn) collisions.append(j+circNum);
            	
            }
    	}
    	// Check against all boxes
    	for (int j = 0; j < boxNum; j++){ // circle-box
        	if (circList[i].isColliding(boxList[j])){
            	//println("Collision between " + str(i) + " and " + str(j+circNum+lineNum));
            	boolean alreadyIn = false;
            	for (int k = 0; k < collisions.size(); k++){
                	if (collisions.get(k) == (i)){
                    	alreadyIn = true;
                    	break;
                	}
            	} if (!alreadyIn) {collisions.append(i); circlesHere++;}
            	// Time to check if the box is already in the list
        		alreadyIn = false;
        		for (int k = 0; k < collisions.size(); k++){
            		if (collisions.get(k) == (j+circNum+lineNum)){
            			alreadyIn = true;
            			break;
            		}	
        		} if (!alreadyIn) collisions.append(j+circNum+lineNum);
    		}
    	}	
	}
	
	//println("Checking lines vs the last two shapes");
	for (int i = 0; i < lineNum; i++){ // line-line
        // Check against all other lines with a line
        for (int j = (i + 1); j < lineNum; j++){
            if (lineList[i].isColliding(lineList[j])){
                //println("Collision between line " + str(i+circNum) + " and line " + str(j+circNum));
                boolean alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == (i+circNum)){
                        alreadyIn = true;
                        break;    
                    }
                } if (!alreadyIn) collisions.append(i+circNum);
                // Time to check if the other circle is already in the list
                alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == (j+circNum)){
                        alreadyIn = true;
                        break;    
                    }
                } if (!alreadyIn) collisions.append(j+circNum);
            }
        }
        // Check against all boxes with a line
        for (int j = 0; j < boxNum; j++){ // line-box
        	//println("Looking at line " + str(i+circNum) + " and box " + str(j+circNum+lineNum));
            if (lineList[i].isColliding(boxList[j])){
                //println("Collision between line " + str(i+circNum) + " and box " + str(j+circNum+lineNum));
                boolean alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == (i+circNum)){
                        alreadyIn = true;
                        break;
                    }
                } if (!alreadyIn) collisions.append(i+circNum);
                // Time to check if the box is already in the list
                alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == (j+circNum+lineNum)){
                        alreadyIn = true;
                        break;
                    }    
                } if (!alreadyIn) collisions.append(j+circNum+lineNum);
            }
        }    
	}

	//println("Checking box v box, the final stretch");
	for (int i = 0; i < boxNum; i++){ // box-box
        // Check against all other boxes
        for (int j = (i + 1); j < boxNum; j++){
            if (boxList[i].isColliding(boxList[j])){
                //println("Collision between box " + str(i+circNum+lineNum) + " and box " + str(j+circNum+lineNum));
                boxbox++;
                boxbox++;
                boolean alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == (i+circNum+lineNum)){
                        alreadyIn = true;
                        break;    
                    }
                } if (!alreadyIn) collisions.append(i+circNum+lineNum);
                // Time to check if the other circle is already in the list
                alreadyIn = false;
                for (int k = 0; k < collisions.size(); k++){
                    if (collisions.get(k) == (j+circNum+lineNum)){
                        alreadyIn = true;
                        break;    
                    }
                } if (!alreadyIn) collisions.append(j+circNum+lineNum);
            }
        }
	}
	int endTime = millis();
	output.println("Duration: " + str(endTime - startTime) + "ms");
	output.println("Num Collisions: " + str(collisions.size()));
	collisions.sort();
	for (int i : collisions){
		output.println(i);
	}
	output.flush();
	output.close();
	exit();
}

//void draw() {
//    background(255);
//    scale(80);
//	for (int i = 0; i < circNum; i++){
//		circle(circList[i].pos.x, circList[i].pos.y, circList[i].r*2);
//	}
//	rectMode(CENTER);
//	for (int i = 0; i < boxNum; i++){
//    	stroke(10, 10, 155);
//    	fill(155, 10, 10);
//		rect(boxList[i].pos.x, boxList[i].pos.y, boxList[i].w, boxList[i].h);
//	}
//	stroke(10, 155, 10);
//	for (int i = 0; i < lineNum; i++){
//		line(lineList[i].l1.x, lineList[i].l1.y, lineList[i].l2.x, lineList[i].l2.y);
//	}
//}





public class Circle {
    public Vec2 pos;
    public float r;
    
    public Circle(float x, float y, float r){
        pos = new Vec2(x,y);
        this.r = r;
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
        l1 = new Vec2(x1, y1);
        l2 = new Vec2(x2, y2);
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
    
    

//---------------
//Vec 2 Library
//---------------

//Vector Library
//CSCI 5611 Vector 2 Library [Example]
// Stephen J. Guy <sjguy@umn.edu>

public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ "," + y +")";
  }
  
  public float length(){
    return sqrt(x*x+y*y);
  }
  
  public float lengthSqr(){
    return x*x+y*y;
  }
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x, y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x, y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs, y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void clampToLength(float maxL){
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  
  public void setToLength(float newL){
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }
  
  public void normalize(){
    float magnitude = sqrt(x*x + y*y);
    x /= magnitude;
    y /= magnitude;
  }
  
  public Vec2 normalized(){
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }
  
  public float distanceTo(Vec2 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    return sqrt(dx*dx + dy*dy);
  }
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x + a.y*b.y;
}

Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(a.x*b.x + a.y*b.y);
}

// Addition added for cross product
float cross(Vec2 a, Vec2 b){
    return (a.x * b.y) - (a.y * b.x);
}

    
