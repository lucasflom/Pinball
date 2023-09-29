int numBalls = 2;

String fname = "level1.txt";

Circle[] balls = new Circle[numBalls];

int numCircs;
Circle[] circObs;
int numLines;
Line[] lineObs;
int numBoxes;
Box[] boxObs; 

float cor = 0.75f; // Coefficient of Restitution

Box lFlipper;
Box rFlipper;


void resetBalls(){
    for (int i = 0; i < numBalls; i++) {
        Vec2 pos = new Vec2(random(width/3, (2*width)/3), 25);
        Vec2 vel = new Vec2(50, 0);
        int rad = 15;
        float mass = ((3.141592653 * (rad * rad))/rad) * ((3.141592653 * (rad * rad))/rad);
        balls[i] = new Circle(pos, rad, mass, vel);
    }
}

void setup() {
    size(1000,1000);
    smooth();
    noStroke();
    resetBalls();

    lFlipper = new Box((width/2)-110, height-20, 100, 10);
    rFlipper = new Box((width/2)+60, height-20, 100, 10);    

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
    }
    // end billiards code
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
  if (keyCode == UP) upPressed = false; 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}

void draw(){
    updatePhysics(1/frameRate);
    background(255);
    fill(255, 0, 0);
    stroke(0,0,0);
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
    rectMode(CENTER);
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

    //draw the flippers
    if (leftPressed) {
      pushMatrix();
      translate(lFlipper.pos.x, lFlipper.pos.y - lFlipper.h/2);
      rotate(-(45*PI)/180);
      rect(lFlipper.h*2, -(tan((45*PI)/180)*(lFlipper.w/2)), lFlipper.w, lFlipper.h);
      rotate((45*PI)/180);
      translate(-(lFlipper.pos.x), -lFlipper.pos.y + lFlipper.h/2);
      popMatrix();
    } else {
      rect(lFlipper.pos.x, lFlipper.pos.y, lFlipper.w, lFlipper.h);
    }
    rect(rFlipper.pos.x, rFlipper.pos.y, rFlipper.w, rFlipper.h);
}
