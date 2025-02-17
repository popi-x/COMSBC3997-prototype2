// Variables
float birdX,birdY, birdVelocity, gravity;
float pipeWidth, pipeGap, pipeX, pipeHeight;
float invincibleTime;
int score;
boolean gameOver;
int gameState;
boolean gravityInverted;

float triangleX, triangleY;
float triangleSpeed = 3;
boolean showTriangle, isInvincible;

void setup() {
  size(1000, 600);
  invincibleTime = -1;
  birdX = 300;
  birdY = height / 2;
  birdVelocity = 0;
  gravity = 0.6;
  pipeWidth = 50;
  pipeGap = 150;
  pipeX = width;
  pipeHeight = random(50, 300);
  score = 0;
  gameOver = false;
  gameState = 0;
  gravityInverted = false;
  showTriangle = false;
  isInvincible = false;
}

void draw() {
  background(135, 206, 250);
  
  if (gameState == 0){
    textAlign(CENTER);
    fill(255);
    textSize(50);
    text("Flappy Bird Clone", width / 2, height / 3);
    textSize(32);
    text("Press SPACE to Start", width / 2, height / 2);
  }
  
  // When game is active
  else if (gameState == 1){
   
    noStroke();
    
    // Pipe Movement
    pipeX -= 3;
    if (pipeX < -pipeWidth) {
      pipeX = width;
      pipeHeight = random(50, 300);
      score++;
    
      // Controls frequency and placement of triangle spawn
      showTriangle = random(1) < 0.4;
      if(showTriangle){
        triangleX = width + 30;
        triangleY = pipeHeight + pipeGap / 2;
      }  
    }
  
    // Triangle movement
    if(showTriangle){
      triangleX -= triangleSpeed;
    }

    // Upper Pipe
    fill(34, 139, 34);
    rect(pipeX, 0, pipeWidth, pipeHeight);

    // Lower Pipe
    rect(pipeX, pipeHeight + pipeGap, pipeWidth, height);
    
    // Triangle Dimensions and collision detection
    if (showTriangle){
      fill(255, 0, 0);
      triangle(triangleX - 15, triangleY + 15, triangleX + 15, triangleY + 15, triangleX, triangleY - 15);
      
      if(dist(birdX, birdY, triangleX, triangleY) < 30) {
        invincibleTime = millis();
        gravityInverted = !gravityInverted;
        showTriangle = false;
        isInvincible = true;
      }
    }
    
    birdVelocity += (gravityInverted ? -gravity : gravity);
    birdY += birdVelocity;
    
    if (isInvincible){
      if (millis() - invincibleTime >= 8000){
        isInvincible = false;
        invincibleTime = -1;
      }
      else{
        fill(255);
        ellipse(birdX, birdY, 30, 30);
      }
    }
    else {
      fill(255, 204, 0);
      noStroke();
      ellipse(birdX, birdY, 30, 30);
    }

    
    
    // Score Display
    fill(255);
    textSize(32);
    text(score, width - 50, 50);

    // Collision Detection with screen and pipes
    if (
      birdY > height || 
      birdY < 0 || 
      (birdX > pipeX && birdX < pipeX + pipeWidth && 
      (birdY < pipeHeight || birdY > pipeHeight + pipeGap))
    ) {
      if (isInvincible){
        birdVelocity = 0;
        birdY = height/2;
        fill(255);
        ellipse(birdX, birdY, 30, 30);
        isInvincible = false;
      }
      else{
        gameOver = true;
        gameState = 2;
      }
     
    }
   
   
    
 }
 
 // Game Over text
 else if (gameState == 2) {
    textAlign(CENTER);
    fill(255);
    textSize(64);
    text("Game Over", width / 2, height / 3);
    textSize(32);
    text("Score: " + score, width / 2, height / 2);
    text("Press SPACE to Restart", width / 2, height / 1.5);
  }
 
}

void keyPressed() {
  if (key == ' ') {
    if(gameState == 0){
      gameState = 1;
    }
    else if (gameState == 1){
      birdVelocity = gravityInverted ? 10 : -10;
    }
    else if(gameState == 2){
      resetGame();
      gameState = 1;
    }
  }
}

void resetGame(){
  birdY = height / 2;
  birdVelocity = 0;
  gravity = 0.6;
  pipeWidth = 50;
  pipeGap = 150;
  pipeX = width;
  pipeHeight = random(50,300);
  score = 0;
  gameOver = false;
  gravityInverted = false;
  showTriangle = false;
  invincibleTime = -1;
  isInvincible = false;
}
