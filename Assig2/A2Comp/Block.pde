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
      switch(lives)
      {
        case 3: c = color(0, 255, 0); break;
        case 2: c = color(255, 128, 0); break;
        case 1: c = color(255, 0, 0); break;
      }
    fill(c);
    noStroke();
    rect(p.x, p.y, W, H);
  }
  
  void collide()
  {
    if(lives <= 0) return;
    //Calculate the edges of the ball and bat for a left of bat collision
    float ballEdgeRPosX = ballPos.x + ballSize/2;
    float batEdgeLPosX = p.x - W/2;
    
    //Calculate the edges of the ball and bat for a right of bat collision
    float ballEdgeLPosX = ballPos.x - ballSize/2;
    float batEdgeRPosX = p.x + W/2;
    
    //Calculate the edges of the ball and bat for a bottom of bat collision
    float ballEdgeTPosY = ballPos.y - ballSize/2;
    float batEdgeBPosY = p.y + H/2;
    
    //Calculate the edges of the ball and bat for a top of bat collision
    float ballEdgeBPosY = ballPos.y + ballSize/2;
    float batEdgeTPosY = p.y - H/2;
    
    //Distance of edge of ball from left of bat
    float distanceBatL = batEdgeLPosX - ballEdgeRPosX;
    
    //Distance of edge of ball from right of bat
    float distanceBatR = ballEdgeLPosX - batEdgeRPosX;
    
    //Distance of edge of ball from top of bat
    float distanceBatT =  batEdgeTPosY - ballEdgeBPosY; 
    
    //Distance of edge of ball from bottom of bat
    float distanceBatB =  ballEdgeTPosY - batEdgeBPosY;
    
    if(abs(ballPos.y - p.y) < (ballSize + H) / 2) //Ensure the y position of the ball is within the y range of the bat
    {
      if(distanceBatL <= 0 && distanceBatL > -W/2) //Only count if ball is within the left half of the bat
      {
        ballPos.x = ballPos.x + distanceBatL; //Correct for sub-surface collision
        ballVel.x = -abs(ballVel.x); //Make ball velocity towards the left
        hit();
      }
      
      if(distanceBatR <= 0 && distanceBatR > -W/2) //Only count if ball is within the right half of the bat
      {
        ballPos.x = ballPos.x - distanceBatR; //Correct for sub-surface collision
        ballVel.x = abs(ballVel.x); //Make ball velocity towards the right
        hit();
      }
    }
    
    if(abs(ballPos.x - p.x) < (ballSize + W) / 2) //Ensure the x position of the ball is within the x range of the bat
    {
      if(distanceBatT <= 0 && distanceBatT > -H/2) //Only count if ball is within the bottom half of the bat
      {
        ballPos.y = ballPos.y + distanceBatT; //Correct for sub-surface collision
        ballVel.y = -abs(ballVel.y); //Make ball velocity towards the top
        hit();
      }
      
      if(distanceBatB <= 0 && distanceBatB > -H/2) //Only count if ball is within the top half of the bat
      {
        ballPos.y = ballPos.y - distanceBatB; //Correct for sub-surface collision
        ballVel.y = abs(ballVel.y); //Make ball velocity towards the bottom
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
