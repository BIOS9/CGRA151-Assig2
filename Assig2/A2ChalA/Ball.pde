class Ball
{
  PVector pos = new PVector(width/2, 0); // Ball Position
  PVector vel = new PVector(0.01, 0); // Ball Velocity
  PVector accel = new PVector(0, 0.0002); // Ball acceleration
  float size = 30; 
  
  Ball(PVector position)
  {
    pos = position;
  }
  
  void update(long delta)
  {
    vel.add(PVector.mult(accel, delta)); // Change velocity by acceleration
    vel.div(airDamping);
    pos.add(PVector.mult(vel, delta)); // Change position by velocity
  }
  
  void render()
  {
    ellipse(pos.x, pos.y, size, size); //Draw the ball
  }
  
  void collide()
  {
    for(Ball b : balls)
      checkBallCollision(b); //Check if the ball is colliding with other balls
    checkWallCollision(); //Check if the ball is colliding with the walls
  }
  
  //Some code/ideas used from https://processing.org/examples/bouncybubbles.html in the method below
  void checkBallCollision(Ball b)
  {
    float dist = PVector.dist(pos, b.pos);
    if(dist > (size + b.size) / 2 || b == this) return; //If ball is too far away or balls are equal
    
    PVector diff = new PVector(b.pos.x - pos.x, b.pos.y - pos.y); //Get difference vector between centres of balls
    float centreDist = (size + b.size) / 2; //Distance of the centres of the balls if the edges were touching
    
    float angle = atan2(diff.y, diff.x); //Get angle of collision 
    PVector target = new PVector(pos.x + cos(angle) * centreDist, pos.y + sin(angle) * centreDist); //Calculate the target co-ordinate of the centre after the collision for 
    
    float spring = 0.001; //Springyness of the balls
    
    //Calculate instantaneous acceleration values for the balls
    float ax = (target.x - b.vel.x) * spring;
    float ay = (target.y - b.vel.y) * spring;
    
    //Change the velocity by the acceleration and add damping
    vel.x -= ax * ballCollisionDamping;
    vel.y -= ay * ballCollisionDamping;
    b.vel.x += ax * ballCollisionDamping;
    b.vel.y += ay * ballCollisionDamping;
  }
  
  void checkWallCollision()
  {
    if(pos.y + (size / 2) > height) // Collision with floor
    {
      vel.y = -abs(vel.y) + collisionDamping; //Change direction
      // Compensating for ball going below floor surface.
      // Line that the centre of ball bounces off is at: y=height - ballSize/2
      // To get distance that the centre of the ball is over the line: p.y + height - ballSize/2
      // We must then take this distance set the y position of the ball to the distance minus the centre bounce line: height - ballsize/2 - p.y + height - ballSize/2
      // Simplified: 2*height - ballSize - p.y
      pos.y = 2*height - size - pos.y;
    }
    else if(pos.y - (size / 2) < 0) // Collision with ceiling
    {
      vel.y = abs(vel.y) - collisionDamping; //Change direction
      pos.y = size - pos.y; //Same maths as above
    }
    
    if(pos.x + (size / 2) > width) // Collision with right wall
    {
      vel.x = -abs(vel.x) + collisionDamping; //Change direction
      pos.x = 2*width - size - pos.x;  //Same maths as above
    }
    else if(pos.x - (size / 2) < 0) // Collision with left wall
    {
      vel.x = abs(vel.x) - collisionDamping; //Change direction
      pos.x = size - pos.x; //Same maths as above
    }
  }
}
