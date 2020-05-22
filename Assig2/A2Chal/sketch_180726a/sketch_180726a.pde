float rp = 0; //Rotational position
float rv = 0; //Rotational velocity
float ra = 0; //Rotational acceleration

PVector p = new PVector(0, 0); // Position
PVector v = new PVector(1, 2); // Velocity
PVector a = new PVector(0, 0.001); // Acceleration

float ballSize = 30;

float max = 0;

float temp = 0;

float collisionDamping = 0.03;
float airDamping = 1.0002;

long lastMillis = millis();

void setup()
{
  size(500, 500);
  frameRate(120);
  p = new PVector(width/2, height/2);
}

void draw()
{ 
  long delta = deltaTime();
  
  background(0);
  stroke(255);
  
  ellipse(p.x, p.y, ballSize, ballSize);
  
  v.add(PVector.mult(a, delta)); // Change velocity by acceleration
  v.div(airDamping);
  p.add(PVector.mult(v, delta)); // Change position by velocity
  println(delta);
  checkCollision();
  
  stroke(255,0,0);
  line(0, height / 2, width, height / 2); 
}

long deltaTime()
{
  long current = millis();
  long delta = current - lastMillis;
  lastMillis = current;
  return delta;
}

void checkCollision()
{
  if(p.y + (ballSize / 2) > height) // Collision with floor
  {
    
    v.y = -abs(v.y) + collisionDamping; //Change direction
    // Compensating for ball going below floor surface.
    // Line that the centre of ball bounces off is at: y=height - ballSize/2
    // To get distance that the centre of the ball is over the line: p.y + height - ballSize/2
    // We must then take this distance set the y position of the ball to the distance minus the centre bounce line: height - ballsize/2 - p.y + height - ballSize/2
    // Simplified: 2*height - ballSize - p.y
    p.y = 2*height - ballSize - p.y;
  }
  else if(p.y - (ballSize / 2) < 0) // Collision with ceiling
  {
    v.y = abs(v.y) - collisionDamping; //Change direction
    p.y = ballSize - p.y; //Same maths as above
  }
  
  if(p.x + (ballSize / 2) > width) // Collision with right wall
  {
    v.x = -abs(v.x) + collisionDamping; //Change direction
    p.x = 2*width - ballSize - p.x;  //Same maths as above
  }
  else if(p.x - (ballSize / 2) < 0) // Collision with left wall
  {
    v.x = abs(v.x) - collisionDamping; //Change direction
    p.x = ballSize - p.x; //Same maths as above
  }
}
