PVector ballPos = new PVector(0, 0); // Ball Position
PVector ballVel = new PVector(0.2, 0.2); // Ball Velocity

int blockCount = 50;
int margin = 20;

//Bat dimentions
Block[] blocks = new Block[blockCount];
Block bat = new Block(new PVector(0,0), 30, 90, true);

float ballSize = 30;
//Store time of last frame
long lastMillis = millis();

void setup()
{
  size(500, 500);
  frameRate(60);
  ballPos = new PVector(width/2, height/2);
  for(int i = 0; i < blockCount; ++i)
  {
    blocks[i] = new Block(new PVector(random(margin, width - margin), random(margin, height - margin)),  20, 10, false);
  }
}

void draw()
{ 
  long delta = deltaTime(); //Get time delta from last frame
  
  background(0);
  stroke(255);
  rectMode(CENTER);
  
  //Draw objects
  for(int i = 0; i < blockCount; ++i)
  {
    blocks[i].render();
    blocks[i].collide();
  }
  bat.render();
  fill(255);
  ellipse(ballPos.x, ballPos.y, ballSize, ballSize); //Draw the ball
  
  //Calculate positions
  ballPos.add(PVector.mult(ballVel, delta)); // Change position by velocity
  bat.p.x = mouseX;
  bat.p.y = mouseY;
  
  
  checkWallCollision(); //Check if the ball is colliding with the walls
  bat.collide();
}

long deltaTime()
{
  long current = millis();
  long delta = current - lastMillis;
  lastMillis = current;
  return delta;
}

void checkWallCollision()
{
  if(ballPos.y + (ballSize / 2) > height) // Collision with floor
  {
    ballVel.y = -abs(ballVel.y); //Change direction
    // Compensating for ball going below floor surface.
    // Line that the centre of ball bounces off is at: y=height - ballSize/2
    // To get distance that the centre of the ball is over the line: p.y + height - ballSize/2
    // We must then take this distance set the y position of the ball to the distance minus the centre bounce line: height - ballsize/2 - p.y + height - ballSize/2
    // Simplified: 2*height - ballSize - p.y
    ballPos.y = 2*height - ballSize - ballPos.y;
  }
  else if(ballPos.y - (ballSize / 2) < 0) // Collision with ceiling
  {
    ballVel.y = abs(ballVel.y); //Change direction
    ballPos.y = ballSize - ballPos.y; //Same maths as above
  }
  
  if(ballPos.x + (ballSize / 2) > width) // Collision with right wall
  {
    ballVel.x = -abs(ballVel.x); //Change direction
    ballPos.x = 2*width - ballSize - ballPos.x;  //Same maths as above
  }
  else if(ballPos.x - (ballSize / 2) < 0) // Collision with left wall
  {
    ballVel.x = abs(ballVel.x); //Change direction
    ballPos.x = ballSize - ballPos.x; //Same maths as above
  }
}
