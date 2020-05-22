float collisionDamping = 0.01;
float ballCollisionDamping = 0.8;
float airDamping = 1.002;

Block[] blocks = new Block[3];
Ball[] balls = new Ball[3];
//Store time of last frame
long lastMillis = millis();

void setup()
{
  size(500, 500);
  frameRate(60);
  
  balls[0] = new Ball(new PVector(width/2, 80));
  balls[1] = new Ball(new PVector(width/2, 0));
  balls[2] = new Ball(new PVector(width/2 + 50, 0));
}

void draw()
{ 
  long delta = deltaTime(); //Get time delta from last frame
  
  background(0);
  stroke(255);
  rectMode(CENTER);
  fill(255);
  //Draw objects
  for(int i = 0; i < 3; ++i)
  {
    balls[i].collide(); //Check collision of balls
    balls[i].update(delta); //Update ball position
    balls[i].render(); //Render the ball
  }
}

//Method to get time difference between frames
long deltaTime()
{
  long current = millis();
  long delta = current - lastMillis;
  lastMillis = current;
  return delta;
}
