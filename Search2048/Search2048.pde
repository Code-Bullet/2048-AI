
Player p;
boolean released = true;
boolean teleport = false;

int maxDepth = 4;
//this means that there is some information specific to the game to input here

int pauseCounter = 100;
int nextConnectionNo = 1000;
int speed = 60;
int moveSpeed = 60;


int xoffset = 0;
int yoffset = 0;

void setup() {
  frameRate(60);
  size(850, 850);
  p = new Player();
}



void draw() {
  background(187,173,160);
  fill(205,193,180);
  for(int i = 0 ; i< 4 ;i++){
    for(int j =0; j< 4 ;j++){
      rect(i*200 + (i+1) *10, j*200 + (j+1) *10, 200, 200);  
    
    }
    
    
  }
  p.move();
  p.show();
  
  if(p.doneMoving()){
    p.getMove();
    p.moveTiles();
  }
}


void keyPressed() {
  if (released) {
    switch(key) {
    case CODED:
      switch(keyCode) {
      case UP:
        if (p.doneMoving()) {
          p.moveDirection = new PVector(0, -1);
          p.moveTiles();
        }
        break;
      case DOWN:
        if (p.doneMoving()) {
          p.moveDirection = new PVector(0, 1);
          p.moveTiles();
        }
        break;
      case LEFT:
        if (p.doneMoving()) {
          p.moveDirection = new PVector(-1, 0);
          p.moveTiles();
        }
        break;
      case RIGHT:
        if (p.doneMoving()) {
          p.moveDirection = new PVector(1, 0);
          p.moveTiles();
        }
        break;
      }
    }
    released = false;
  }
}

void keyReleased(){
 released = true; 
  
}

boolean compareVec(PVector p1, PVector p2) {
  if (p1.x == p2.x && p1.y == p2.y) {
    return true;
  }
  return false;
}