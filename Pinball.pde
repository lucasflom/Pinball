int numBalls = 2;

Circle[] balls = new Circle[numBalls];

float cor = 0.75f; // Coefficient of Restitution

void resetBalls(){
    for (int i = 0; i < numBalls; i++) {
        Vec2 pos = new Vec2(random(width/3, (2*width)/3), 20);
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
}

void updatePhysics(float dt) {
    // used the following code (modified) from the billiard example in class
    
    // Update ball ballPositions
    for (int i = 0; i < numBalls; i++){
        balls[i].vel.add(new Vec2(0,9.81));
        balls[i].pos.add(balls[i].vel.times(dt));

        // Ball-Wall Collision (account for ballRad)
        if (balls[i].pos.x < balls[i].r){
            balls[i].pos.x = balls[i].r;
            balls[i].vel.x *= -cor;
        }
        if (balls[i].pos.x > width - balls[i].r){
            balls[i].pos.x = width - balls[i].r;
            balls[i].vel.x *= -cor;
        }
        if (balls[i].pos.y < balls[i].r){
            balls[i].pos.y = balls[i].r;
            balls[i].vel.y *= -cor;
        }
        if (balls[i].pos.y > height - balls[i].r){
            balls[i].pos.y = height - balls[i].r;
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

void draw(){
    updatePhysics(1/frameRate);
    background(255);
    fill(255, 0, 0);
    stroke(0,0,0);
    // draw borders
    strokeWeight(5);
    Line[] walls = {new Line(10.0, 10.0, 10.0, float(height - 10)), new Line(10.0, 10.0, float(width - 10), 10.0), new Line(float(width - 10), 10.0, float(width - 10), float(height - 10)), new Line(10, float(height - 10), float(width - 10), float(height - 10))};
    strokeWeight(1);

    for (int i = 0; i < walls.length; i++) {
        line(walls[i].l1.x, walls[i].l1.y, walls[i].l2.x, walls[i].l2.y);
    }

    // draw the balls
    for (int i = 0; i < numBalls; i++) {
        ellipse(balls[i].pos.x, balls[i].pos.y, balls[i].r * 2, balls[i].r * 2);
        for (int j = 0; j < walls.length; j++) {
            println(balls[i].isColliding(walls[j]));
        }
    }
}
