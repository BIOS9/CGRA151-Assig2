public class Block
{
  long lastHit = millis();
  long hitDebounceDelay = 100;
  float W, H;
  PVector p = new PVector(0, 0);
  boolean invulnerable;
  int lives = 3;
  
  Block(PVector position, float w, float h, boolean invuln)
  {
    invulnerable = invuln;
    p = position;
    W = w;
    H = h;
  }
  
  void render()
  {
    if(lives <= 0) return;
    color c = color(255);
    if(!invulnerable)
      switch(lives) //Switch color depending on life count
      {
        case 3: c = color(0, 255, 0); break;
        case 2: c = color(255, 128, 0); break;
        case 1: c = color(255, 0, 0); break;
      }
    fill(c);
    noStroke();
    rect(p.x, p.y, W, H);
  }
  
  void collide(Ball ball)
  {
    if(lives <= 0) return;
    //Calculate the edges of the ball and bat for a left of bat collision
    float ballEdgeRPosX = ball.pos.x + ball.size/2;
    float batEdgeLPosX = p.x - W/2;
    
    //Calculate the edges of the ball and bat for a right of bat collision
    float ballEdgeLPosX = ball.pos.x - ball.size/2;
    float batEdgeRPosX = p.x + W/2;
    
    //Calculate the edges of the ball and bat for a bottom of bat collision
    float ballEdgeTPosY = ball.pos.y - ball.size/2;
    float batEdgeBPosY = p.y + H/2;
    
    //Calculate the edges of the ball and bat for a top of bat collision
    float ballEdgeBPosY = ball.pos.y + ball.size/2;
    float batEdgeTPosY = p.y - H/2;
    
    //Distance of edge of ball from left of bat
    float distanceBatL = batEdgeLPosX - ballEdgeRPosX;
    
    //Distance of edge of ball from right of bat
    float distanceBatR = ballEdgeLPosX - batEdgeRPosX;
    
    //Distance of edge of ball from top of bat
    float distanceBatT =  batEdgeTPosY - ballEdgeBPosY; 
    
    //Distance of edge of ball from bottom of bat
    float distanceBatB =  ballEdgeTPosY - batEdgeBPosY;
    
    if(abs(ball.pos.y - p.y) < (ball.size + H) / 2) //Ensure the y position of the ball is within the y range of the bat
    {
      if(distanceBatL <= 0 && distanceBatL > -10) //Only count if ball is within -10 units below the surface of the block
      {
        ball.pos.x = ball.pos.x + distanceBatL; //Correct for sub-surface collision
        ball.vel.x = -abs(ball.vel.x) + collisionDamping; //Make ball velocity towards the left
        hit();
      }
      
      if(distanceBatR <= 0 && distanceBatR > -10) //Only count if ball is within -10 units below the surface of the block
      {
        ball.pos.x = ball.pos.x - distanceBatR; //Correct for sub-surface collision
        ball.vel.x = abs(ball.vel.x) - collisionDamping; //Make ball velocity towards the right
        hit();
      }
    }
    
    if(abs(ball.pos.x - p.x) < (ball.size + W) / 2) //Ensure the x position of the ball is within the x range of the bat
    {
      if(distanceBatT <= 0 && distanceBatT > -10) //Only count if ball is within -10 units below the surface of the block
      {
        ball.pos.y = ball.pos.y + distanceBatT; //Correct for sub-surface collision
        ball.vel.y = -abs(ball.vel.y) + collisionDamping; //Make ball velocity towards the top
        hit();
      }
      
    if(distanceBatB <= 0 && distanceBatB > -10) //Only count if ball is within -10 units below the surface of the block
      {
        ball.pos.y = ball.pos.y - distanceBatB; //Correct for sub-surface collision
        ball.vel.y = abs(ball.vel.y) - collisionDamping; //Make ball velocity towards the bottom
        hit();
      }
    }
  }
  
  void hit()
  {
    if(!invulnerable && millis() - lastHit > hitDebounceDelay)
    {
      lastHit = millis();
      --lives;
    }
  }

}
