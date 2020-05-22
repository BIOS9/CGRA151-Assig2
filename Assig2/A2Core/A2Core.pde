PVector ballPos = new PVector(0, 0); // Ball Position
PVector ballVel = new PVector(0.2, 0.2); // Ball Velocity

PVector batPos = new PVector(0, 0); // Bat Position

//Bat dimentions
float batW = 50;
float batH = 70;

float ballSize = 30;

//Store time of last frame
long lastMillis = millis();

void setup()
{
  size(500, 500);
  frameRate(60);
  ballPos = new PVector(width/2, height/2);
}

void draw()
{ 
  long delta = deltaTime(); //Get time delta from last frame
  
  background(0);
  stroke(255);
  rectMode(CENTER);
  
  //Draw objects
  rect(batPos.x, batPos.y, batW, batH);
  ellipse(ballPos.x, ballPos.y, ballSize, ballSize); //Draw the ball
  
  //Calculate positions
  ballPos.add(PVector.mult(ballVel, delta)); // Change position by velocity
  batPos.x = mouseX;
  batPos.y = mouseY;
  
  
  checkWallCollision(); //Check if the ball is colliding with the walls
  checkBatCollision(); //Check if the ball is colliding with the bat
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

void checkBatCollision()
{
  //Calculate the edges of the ball and bat for a left of bat collision
  float ballEdgeRPosX = ballPos.x + ballSize/2;
  float batEdgeLPosX = batPos.x - batW/2;
  
  //Calculate the edges of the ball and bat for a right of bat collision
  float ballEdgeLPosX = ballPos.x - ballSize/2;
  float batEdgeRPosX = batPos.x + batW/2;
  
  //Calculate the edges of the ball and bat for a bottom of bat collision
  float ballEdgeTPosY = ballPos.y - ballSize/2;
  float batEdgeBPosY = batPos.y + batH/2;
  
  //Calculate the edges of the ball and bat for a top of bat collision
  float ballEdgeBPosY = ballPos.y + ballSize/2;
  float batEdgeTPosY = batPos.y - batH/2;
  
  //Distance of edge of ball from left of bat
  float distanceBatL = batEdgeLPosX - ballEdgeRPosX;
  
  //Distance of edge of ball from right of bat
  float distanceBatR = ballEdgeLPosX - batEdgeRPosX;
  
  //Distance of edge of ball from top of bat
  float distanceBatT =  batEdgeTPosY - ballEdgeBPosY; 
  
  //Distance of edge of ball from bottom of bat
  float distanceBatB =  ballEdgeTPosY - batEdgeBPosY;
  
  if(abs(ballPos.y - batPos.y) < (ballSize + batH) / 2) //Ensure the y position of the ball is within the y range of the bat
  {
    if(distanceBatL <= 0 && distanceBatL > -batW/2) //Only count if ball is within the left half of the bat
    {
      ballPos.x = ballPos.x + distanceBatL; //Correct for sub-surface collision
      ballVel.x = -abs(ballVel.x); //Make ball velocity towards the left
    }
    
    if(distanceBatR <= 0 && distanceBatR > -batW/2) //Only count if ball is within the right half of the bat
    {
      ballPos.x = ballPos.x - distanceBatR; //Correct for sub-surface collision
      ballVel.x = abs(ballVel.x); //Make ball velocity towards the right
    }
  }
  
  if(abs(ballPos.x - batPos.x) < (ballSize + batW) / 2) //Ensure the x position of the ball is within the x range of the bat
  {
    if(distanceBatT <= 0 && distanceBatT > -batH/2) //Only count if ball is within the bottom half of the bat
    {
      ballPos.y = ballPos.y + distanceBatT; //Correct for sub-surface collision
      ballVel.y = -abs(ballVel.y); //Make ball velocity towards the top
    }
    
    if(distanceBatB <= 0 && distanceBatB > -batH/2) //Only count if ball is within the top half of the bat
    {
      ballPos.y = ballPos.y - distanceBatB; //Correct for sub-surface collision
      ballVel.y = abs(ballVel.y); //Make ball velocity towards the bottom
    }
  }
}
