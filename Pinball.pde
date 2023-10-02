int numBalls = 4;
int ballIndex = 0;

String fname = "level1.txt";

Circle[] balls = new Circle[numBalls];

int numCircs;
Circle[] circObs;
int numLines;
Line[] lineObs;
int numBoxes;
Box[] boxObs; 

float cor = 0.75f; // Coefficient of Restitution

Flipper lFlipper;
Flipper rFlipper;

float lFlipper_rotation = 0.0;
float rFlipper_rotation = 0.0;

void resetBalls(){
    ballIndex = 0;
    for (int i = 0; i < numBalls; i++) {
        Vec2 pos = new Vec2(-100, -100);
        Vec2 vel = new Vec2(0, 0);
        int rad = 15;
        float mass = ((3.141592653 * (rad * rad))/rad) * ((3.141592653 * (rad * rad))/rad);
        balls[i] = new Circle(pos, rad, mass, vel);
    }
}

void launchBalls(){
    if (ballIndex < numBalls){
        Vec2 pos = new Vec2(975, 975);
        Vec2 vel = new Vec2(0, random(-1500, -1200));
        int rad = 15;
        float mass = (2);
        balls[ballIndex] = new Circle(pos, rad, mass, vel);
        ballIndex++;
    }
    

}

void setup() {
    size(1000,1000);
    smooth();
    noStroke();
    resetBalls();

    lFlipper = new Flipper((width/2)-110, height-75, (width/2)-30, height-25);
    rFlipper = new Flipper((width/2)+60, height-25, (width/2)+140, height-75);    

    // read from the file
    String[] lines = loadStrings(fname);
    numCircs = int(lines[0].substring(3));
    numLines = int(lines[numCircs+1].substring(3));
    numBoxes = int(lines[numCircs+numLines+2].substring(3));

    circObs = new Circle[numCircs];
    for (int i = 1; i < (numCircs+1); i++){
        String[] data = lines[i].split(" ");
        circObs[i-1] = new Circle(new Vec2(float(data[1]), float(data[2])), float(data[3]), 10000.0, new Vec2(0,0));
    }
    lineObs = new Line[numLines];
    for (int i = (numCircs + 2); i < (numCircs + numLines + 2); i++){
        String[] data = lines[i].split(" ");
        lineObs[i - (numCircs + 2)] = new Line(float(data[1]), float(data[2]), float(data[3]), float(data[4]));
    }
    boxObs = new Box[numBoxes];
    for (int i = (numCircs + numLines + 3); i < (numCircs + numLines + numBoxes + 3); i++){
        String[] data = lines[i].split(" ");
        boxObs[i - (numCircs + numLines + 3)] = new Box(float(data[1]), float(data[2]), float(data[3]), float(data[4]));
    }
}

void updatePhysics(float dt) {
    // used the following code (modified) from the billiard example in class

    // Update ball ballPositions
    for (int i = 0; i < numBalls; i++){
        balls[i].vel.add(new Vec2(0,9.81));
        balls[i].pos.add(balls[i].vel.times(dt));

        // Ball-Wall Collision (account for ballRad)
        // This works only for "walls" that are padded 10px from the sides of the window
        if (balls[i].pos.x < balls[i].r + 10){
            balls[i].pos.x = balls[i].r + 10;
            balls[i].vel.x *= -cor;
        }
        if (balls[i].pos.x > width - balls[i].r - 10){
            balls[i].pos.x = width - balls[i].r - 10;
            balls[i].vel.x *= -cor;
        }
        if (balls[i].pos.y < balls[i].r + 10){
            balls[i].pos.y = balls[i].r + 10;
            balls[i].vel.y *= -cor;
        }
        if (balls[i].pos.y > height - balls[i].r - 10){
            balls[i].pos.y = height - balls[i].r - 10;
            balls[i].vel.y *= -cor;
        }

        // Ball-Ball Collision
        for (int j = i + 1; j < numBalls; j++){
            Vec2 delta = balls[i].pos.minus(balls[j].pos);
            float dist = delta.length();
            if (dist < balls[i].r + balls[j].r){
                // Move balls out of collision
                float overlap = 0.5f * (dist - balls[i].r - balls[j].r);
                balls[i].pos.subtract(delta.normalized().times(overlap));
                balls[j].pos.add(delta.normalized().times(overlap));


                // Collision
                Vec2 dir = delta.normalized();
                float v1 = dot(balls[i].vel, dir);
                float v2 = dot(balls[j].vel, dir);
                float m1 = balls[i].mass;
                float m2 = balls[j].mass;
                // Vec2 nv1 = (ballVel[i].times(m1)).plus(ballVel[j].times(v2)).minus(((ballVel[i].minus(ballVel[j])).times(cor)).times(m2)).times(1/(m1 + m2));
                // Vec2 nv2 = (ballVel[i].times(m1)).plus(ballVel[j].times(v2)).minus(((ballVel[j].minus(ballVel[i])).times(cor)).times(m1)).times(1/(m1 + m2));
                float nv1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
                float nv2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
                balls[i].vel = balls[i].vel.plus(dir.times(nv1 - v1));
                balls[j].vel = balls[j].vel.plus(dir.times(nv2 - v2));
                // Pseudo-code for collision response
                // new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2)
                // new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2)
                // ball1.ballVel += dir * (new_v1 - v1) # Add the change in ballVelocity along the collision axis
                // ball2.ballVel += dir * (new_v2 - v2) #  ... collisions only affect ballVelocity along this axis!
                // TODO: Implement the above pseudo-code
                // ballVel[i] = new Vec2(0,0); // Replace with correct collisions response ballVelocity
                // ballVel[j] = new Vec2(0,0); // Replace with correct collisions response ballVelocity
            }
        }
        // end billiards code
        // Ball-Circle Collision
        for (int j = 0; j < numCircs; j++){
            Vec2 delta = balls[i].pos.minus(circObs[j].pos);
            float dist = delta.length();
            if (dist < balls[i].r + circObs[j].r){
                // Move out of collision
                float overlap = 0.5f * (dist - balls[i].r - circObs[j].r);
                balls[i].pos.subtract(delta.normalized().times(overlap)); // This line may need to be changed to account for the obstacle not moving
                
                // Collision
                Vec2 dir = delta.normalized();
                float v1 = dot(balls[i].vel, dir);
                float v2 = dot(circObs[j].vel, dir); // Should be 0 as the obstacles have no velocity
                float m1 = balls[i].mass;
                float m2 = circObs[j].mass;
                float nv1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
                float nv2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
                balls[i].vel = balls[i].vel.plus(dir.times(nv1 - v1));
            }
        }
        // Ball-Line Collision
        for (int j = 0; j < numLines; j++){
            Vec2 delta = balls[i].pos.minus(balls[i].closestPoint(lineObs[j]));
            float dist = delta.length();
            if (balls[i].isColliding(lineObs[j])){
                // Move out of collision
                float overlap = (dist - balls[i].r); // Could be major wonky
                balls[i].pos.subtract(delta.normalized().times(overlap));

                // Collision
                Vec2 dir = delta.normalized();
                float v1 = dot(balls[i].vel, dir);
                float v2 = 0.0; // The obstacle never has a velocity
                float m1 = balls[i].mass;
                float m2 = 100000.0; // The mass shouldn't matter?
                float nv1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
                float nv2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
                balls[i].vel = balls[i].vel.plus(dir.times(nv1 - v1));

            }
        }
        // Ball-Box Collision
        for (int j = 0; j < numBoxes; j++){
            Vec2 delta = balls[i].pos.minus(boxObs[j].pos);
            float dist = delta.length();
            if (balls[i].isColliding(boxObs[j])){
                // Move out of collision
                float overlap = (dist - balls[i].r - (boxObs[j].pos.distanceTo(balls[i].closestPoint(boxObs[j])))); // Include the box's side of it too
                balls[i].pos.subtract(delta.normalized().times(overlap));

                // Collision
                Vec2 dir = delta.normalized();
                float v1 = dot(balls[i].vel, dir);
                float v2 = 0.0; // The obstacle never has a velocity
                float m1 = balls[i].mass;
                float m2 = 100000.0; // The mass shouldn't matter?
                float nv1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
                float nv2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
                balls[i].vel = balls[i].vel.plus(dir.times(nv1 - v1));
            }
        }
        // Ball-Flipper Collision (Needs fixing)
        Vec2 delta = balls[i].pos.minus(balls[i].closestPoint(lFlipper));
        float dist = delta.length();
        if (balls[i].isColliding(lFlipper)){
            float overlap = (dist - balls[i].r);
            balls[i].pos.subtract(delta.normalized().times(overlap));
            
            // Collision
            Vec2 dir = delta.normalized();
            float v1 = dot(balls[i].vel, dir);
            // Flipper velocity
            Vec2 radius = balls[i].closestPoint(lFlipper).minus(lFlipper.l1);
            Vec2 surfaceVel = radius.times(lFlipper.angular_vel);
            float v2 = dot(surfaceVel, dir);
            float m1 = balls[i].mass;
            float m2 = 100000.0; // The mass shouldn't matter?
            float nv1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
            float nv2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
            balls[i].vel = balls[i].vel.plus(dir.times(nv1 - v1));
        }

        delta = balls[i].pos.minus(balls[i].closestPoint(rFlipper));
        dist = delta.length();
        if (balls[i].isColliding(rFlipper)){
            float overlap = (dist - balls[i].r);
            balls[i].pos.subtract(delta.normalized().times(overlap));
            
            // Collision
            Vec2 dir = delta.normalized();
            float v1 = dot(balls[i].vel, dir);
            // Flipper velocity
            Vec2 radius = balls[i].closestPoint(lFlipper).minus(lFlipper.l1);
            Vec2 surfaceVel = radius.times(lFlipper.angular_vel);
            float v2 = dot(surfaceVel, dir);
            float m1 = balls[i].mass;
            float m2 = 100000.0; // The mass shouldn't matter?
            float nv1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
            float nv2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
            balls[i].vel = balls[i].vel.plus(dir.times(nv1 - v1));
        }
    }
    
}

boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;
void keyPressed(){
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == UP) upPressed = true; 
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
}

void keyReleased(){
  // reset if 'r' if pressed
  if (key == 'r'){
    resetBalls();
  }
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == UP) launchBalls(); 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}

void draw(){
    background(255);
    fill(255, 0, 0);
    stroke(0,0,0);
    //draw the flippers
    Vec2 l2Bak = new Vec2((width/2)-30, height-25);
    Vec2 l1Bak = new Vec2((width/2)+60, height-25);
    if (leftPressed) {
      lFlipper.angular_vel = 10;
      lFlipper_rotation += lFlipper.angular_vel * (1/frameRate);
      //lFlipper_rotation += ((45*PI)/180)/5; // every dt add this much rotation
      lFlipper_rotation = min(lFlipper_rotation, (50*PI)/180);
      Vec2 nL2 = new Vec2((cos(lFlipper_rotation)*(lFlipper.l2.x - lFlipper.l1.x)) + (sin(lFlipper_rotation) * (lFlipper.l2.y - lFlipper.l1.y)) + lFlipper.l1.x, (-1 * sin(lFlipper_rotation)*(lFlipper.l2.x - lFlipper.l1.x)) + (cos(lFlipper_rotation) * (lFlipper.l2.y - lFlipper.l1.y)) + lFlipper.l1.y);
      l2Bak = lFlipper.l2;
      lFlipper.l2 = nL2;
      ellipse(lFlipper.l2.x, lFlipper.l2.y, 10,10);
      strokeWeight(5);
      line(lFlipper.l1.x, lFlipper.l1.y, lFlipper.l2.x, lFlipper.l2.y);
      strokeWeight(1);
      //resets the line object l2 after drawing the line.. need to check for collisions before this
    } else {
      lFlipper = new Flipper((width/2)-110, height-75, (width/2)-30, height-25);
      lFlipper_rotation = 0.0;
      strokeWeight(5);
      line(lFlipper.l1.x, lFlipper.l1.y, lFlipper.l2.x, lFlipper.l2.y);
      strokeWeight(1);
    }

    if (rightPressed) {
      rFlipper.angular_vel = 10;
      rFlipper_rotation += rFlipper.angular_vel * (1/frameRate);
      rFlipper_rotation = min(rFlipper_rotation, (50*PI)/180);
      Vec2 nL1 = new Vec2((cos(rFlipper_rotation)*(rFlipper.l1.x - rFlipper.l2.x)) + (-1 * sin(rFlipper_rotation) * (rFlipper.l1.y - rFlipper.l2.y)) + rFlipper.l2.x, (sin(rFlipper_rotation)*(rFlipper.l1.x - rFlipper.l2.x)) + (cos(rFlipper_rotation) * (rFlipper.l1.y - rFlipper.l2.y)) + rFlipper.l2.y);
      l1Bak = rFlipper.l1;
      rFlipper.l1 = nL1;
      strokeWeight(5);
      line(rFlipper.l1.x, rFlipper.l1.y, rFlipper.l2.x, rFlipper.l2.y);
      strokeWeight(1);
      //resets the line object l2 after drawing the line.. need to check for collisions before this
    } else {
      rFlipper = new Flipper((width/2)+60, height-25, (width/2)+140, height-75);    
      rFlipper_rotation = 0.0;
      strokeWeight(5);
      line(rFlipper.l1.x, rFlipper.l1.y, rFlipper.l2.x, rFlipper.l2.y);
      strokeWeight(1);
    }

    updatePhysics(1/frameRate);

    if (leftPressed) {
      lFlipper.l2 = l2Bak;
    }
    if (rightPressed) {
      rFlipper.l1 = l1Bak;
    }

    rectMode(CENTER);
    // draw borders
    strokeWeight(5);
    Line[] walls = {new Line(10.0, 10.0, 10.0, float(height - 10)), new Line(10.0, 10.0, float(width - 10), 10.0), new Line(float(width - 10), 10.0, float(width - 10), float(height - 10)), new Line(10, float(height - 10), float(width - 10), float(height - 10))};
    strokeWeight(1);

	// draw the walls
    for (int i = 0; i < walls.length; i++) {
        line(walls[i].l1.x, walls[i].l1.y, walls[i].l2.x, walls[i].l2.y);
    }

    // draw the obstacles
    for (int i = 0; i < numCircs; i++){
      circle(circObs[i].pos.x, circObs[i].pos.y, circObs[i].r*2);
    }
    for (int i = 0; i < numBoxes; i++){
      rect(boxObs[i].pos.x, boxObs[i].pos.y, boxObs[i].w, boxObs[i].h);
    }
    for (int i = 0; i < numLines; i++){
      line(lineObs[i].l1.x, lineObs[i].l1.y, lineObs[i].l2.x, lineObs[i].l2.y);
    }

    // draw the balls
    for (int i = 0; i < numBalls; i++) {
        ellipse(balls[i].pos.x, balls[i].pos.y, balls[i].r * 2, balls[i].r * 2);
    }
}
