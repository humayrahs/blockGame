boolean isAlive;  //is game on or off
int [] bPosX, bSize;  //Arrays for any block item bc multiple blocks :)
int score, plSize, plPosX, plPosY;
float [] bPosY, bSpeed;
float plSpeed; 
float minSpeed = 0;
float maxSpeed = 5;

void setup() {
  //Program Settings
  size(700, 600);
  textAlign(CENTER);
  rectMode(CENTER);

  //Initial Start - 10 blocks at any given time
  int noBlock = 10;
  bPosX = new int[noBlock];
  bSize = new int[noBlock];
  bPosY = new float[noBlock];
  bSpeed = new float[noBlock];
  initGame();
}

void draw() {
  background(255, 200, 200);

  if (isAlive) {  //ie when game is on, player motion is on
    background(200, 200, 250);
    movePlayer();  //Allows left and right movement of the player
    drawPlayer();
    fill(255);
    text(score, width/2, height/2);  //Score display
  }

  //falling blocks regardless if win or lose (for aesthetic reasons)
  for (int i=0; i<bPosX.length; i++) {
    moveBlock(i);   //increases height of falling block(s) as well as acceleration
    drawBlock(i);   //Draws current pos of falling block(s)
    checkFall(i);   //When block hits ground, new block appears
    checkCollision(i);
  }

  if (!isAlive) {  //loss screen
    //drawPlayer();

    fill(255);  //end screen text
    int fontSize = 15;
    textSize(fontSize);
    text("Your score is " + score + ".", width/2, height/2);
    text("Press SPACE to restart game.", width/2, height/2+fontSize);

    if (keyPressed) {  //press space to restart the game
      if (key == ' ') {
        initGame();
      }
    }
  }
}

void initGame() {
  isAlive = true;
  score = 0;
  for (int i =0; i<bPosX.length; i++) {
    initBlock(i);
  }
  initPlayer();
}

void initBlock(int i) {  //randomly allocates block size, spawn point, initial speed
  bPosX[i] = int(random(width));
  bPosY[i] = 0;
  bSize[i] = int(random(10, 20));
  bSpeed[i] = random(minSpeed, maxSpeed);
}

void drawBlock(int i) {  //displays current falling block location
  float blue = i*25;
  stroke(0);
  fill(200, 100, blue);
  square(bPosX[i], bPosY[i], bSize[i]);
}

void moveBlock(int i) {  //accelerate blocks
  bPosY[i] += bSpeed[i];
  bSpeed[i]+=0.1; //acceleration
}

void initPlayer() {
  plSize = 14;
  plPosX = width/2;
  plPosY = height-(plSize/2);
  plSpeed = 8;
}

void drawPlayer() {
  stroke(0);
  fill(200);
  square(plPosX, plPosY, plSize);
}

void movePlayer() {
  if (keyPressed) {
    if (keyCode == LEFT) {
      plPosX -= plSpeed;
    } else if (keyCode == RIGHT) {
      plPosX += plSpeed;
    }
  }
}

void checkFall(int i) {  //score increase -win condition
  if (bPosY[i] > height+(bPosX[i]/2)) {
    initBlock(i);
    if (isAlive) {
      score++;
      if(score%10 == 0){
        minSpeed++;
        maxSpeed++;
      }
    }
  }
}

void checkCollision(int i) {  //lose condition
  float bLeft = bPosX[i]-bSize[i];
  float bRight = bPosX[i]+bSize[i];
  float bHead = bPosY[i]+bSize[i];
  float plLeft = plPosX-plSize;
  float plRight = plPosX+plSize;
  float plHead = plPosY-plSize;

  if (bHead>=plHead && ((bLeft>=plLeft && bLeft<plRight) || (bRight>=plLeft && bRight<plRight))) { //loss condition
    //drawEverything();
    isAlive = false;
  }
}
