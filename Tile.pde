class Tile {
  int value;
  PVector position;
  PVector pixelPos;//top left
  boolean alreadyIncreased = false;
  boolean moving = false;

  color colour;
  PVector positionTo;
  PVector pixelPosTo;


  boolean deathOnImpact =false;

  Tile(int x, int y) {
    if (random(1)< 0.1) {
      value = 4;
    } else {
      value =2;
    }

    position = new PVector(x, y);
    positionTo = new PVector(x, y);

    pixelPos = new PVector(xoffset +x*200 + (x+1) *10, yoffset + y*200 + (y+1) *10);
    pixelPosTo = new PVector(xoffset + x*200 + (x+1) *10, yoffset + y*200 + (y+1) *10);

    setColour();
  }

  //---------------------------------------------------------------------------------------------------------


  void show() {
    if (!deathOnImpact || moving) {
      fill(colour);
      noStroke();
      rect(pixelPos.x, pixelPos.y, 200, 200);
      if (value < 8) {
        fill(40);
      } else {
        fill(240);
      }
      textAlign(CENTER, CENTER);
      textSize(50);
      text(value, pixelPos.x+100, pixelPos.y+100);
    }
  }

  //------------------------------------------------------------------------------------------------------------
  void moveTo(PVector to) {
    positionTo = new PVector(to.x, to.y);
    pixelPosTo = new PVector(xoffset +to.x*200 + (to.x+1) *10, yoffset +to.y*200 + (to.y+1) *10);
    moving = true;
  }
  void moveToNow(PVector to) {
    position = new PVector(to.x, to.y);
    pixelPos = new PVector(xoffset +to.x*200 + (to.x+1) *10, yoffset +to.y*200 + (to.y+1) *10);
  }
  //------------------------------------------------------------------------------------------------------------
  void move(int speed) {
    if (moving) {
      if (!teleport && dist(pixelPos.x, pixelPos.y, pixelPosTo.x, pixelPosTo.y) > speed) {
        PVector MoveDirection = new PVector(positionTo.x - position.x, positionTo.y - position.y); 
        MoveDirection.normalize();
        MoveDirection.mult(speed);
        pixelPos.add(MoveDirection);
      } else {
        moving = false;
        pixelPos = new PVector(pixelPosTo.x, pixelPosTo.y);
        position = new PVector(positionTo.x, positionTo.y);
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------


  void setColour() {
    switch(value) {
    case 2:
      colour = color(238, 228, 218);
      break;
    case 4:
      colour = color(237, 224, 200);
      break;       
    case 8:
      colour = color(242, 177, 121);
      break;
    case 16:
      colour = color(2345, 149, 99);
      break;
    case 32:
      colour = color(246, 124, 95);
      break;
    case 64:
      colour = color(246, 94, 59);
      break;
    case 128:
      colour = color(237, 207, 114);
      break;
    case 256:
      colour = color(237,204,97);
      break;
    case 512:
      colour = color(237,200,80);
      break;
    case 1024:
      colour = color(237,197,63);
      break;
    case 2048:
      colour = color(237,197,1);
      break;
    case 4096:
      colour = color(94,218,146);
      break;
      
    }
  }

  Tile clone() {
    Tile clone = new Tile(floor(position.x), floor(position.y));
    clone.value = value;
    clone.setColour();

    return clone;
  }
}