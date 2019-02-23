class Player {
  long fitness;
  boolean dead = false;
  int score =0;

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  ArrayList<Tile> tiles = new ArrayList<Tile>();
  ArrayList<PVector> emptyPositions = new ArrayList<PVector>();
  PVector moveDirection = new PVector();
  boolean movingTheTiles =false;
  boolean tileMoved = false;

  float[][] startingPositions = new float[2][3];

  State start;


  //constructor

  Player() {
    fillEmptyPositions(); 

    //add 2 tiles

    addNewTile();
    addNewTile();

    startingPositions[0][0] = tiles.get(0).position.x;
    startingPositions[0][1] = tiles.get(0).position.y;
    startingPositions[0][2] = tiles.get(0).value;


    startingPositions[1][0] = tiles.get(1).position.x;
    startingPositions[1][1] = tiles.get(1).position.y;
    startingPositions[1][2] = tiles.get(1).value;
  }

  Player(boolean isReplay) {

    fillEmptyPositions();
  }


  void setTilesFromHistory() {

    tiles.add(new Tile(floor(startingPositions[0][0]), floor(startingPositions[0][1])));
    tiles.get(0).value = floor(startingPositions[0][2]);

    tiles.add(new Tile(floor(startingPositions[1][0]), floor(startingPositions[1][1])));
    tiles.get(1).value = floor(startingPositions[1][2]);


    for ( int i = 0; i< emptyPositions.size(); i ++) {
      if (compareVec(emptyPositions.get(i), tiles.get(0).position) || compareVec(emptyPositions.get(i), tiles.get(1).position)) {
        emptyPositions.remove(i);
        i--;
      }
    }
  }


  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void show() {
    //show the ones which are going to die first so it looks like they slip under the other ones
    for (int i = 0; i< tiles.size(); i++) {
      if (tiles.get(i).deathOnImpact) {
        tiles.get(i).show();
      }
    }

    for (int i = 0; i< tiles.size(); i++) {
      if (!tiles.get(i).deathOnImpact) {
        tiles.get(i).show();
      }
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void move() {
    if (movingTheTiles) {
      for (int i = 0; i< tiles.size(); i++) {
        tiles.get(i).move(moveSpeed);
      }
      if (doneMoving()) {
        for (int i = 0; i< tiles.size(); i++) {//kill collided tiles
          if (tiles.get(i).deathOnImpact) {
            tiles.remove(i);
            i--;
          }
        }

        movingTheTiles =false;
        setEmptyPositions();
        addNewTileNotRandom();
      }
    }
  }

  boolean doneMoving() {

    for (int i = 0; i< tiles.size(); i++) {
      if (tiles.get(i).moving) {
        return false;
      }
    }

    return true;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void update() {
    move();
  }
  //-------------------------------------------------------------------------------------------------------------------------------------

  void fillEmptyPositions() {
    for (int i = 0; i< 4; i++) {
      for (int j =0; j< 4; j++) {
        emptyPositions.add(new PVector(i, j));
      }
    }
  }
  //---------------------------------

  void setEmptyPositions() {
    emptyPositions.clear();
    for (int i = 0; i< 4; i++) {
      for (int j =0; j< 4; j++) {
        if (getValue(i, j) ==0) {
          emptyPositions.add(new PVector(i, j));
        }
      }
    }
  }

  //----------------------------------------------------------------------------------------------------------------------------------------------------



  void moveTiles() {
    tileMoved = false;
    for (int i = 0; i< tiles.size(); i++) {
      tiles.get(i).alreadyIncreased = false;
    }
    ArrayList<PVector> sortingOrder = new ArrayList<PVector>();
    PVector sortingVec = new PVector();
    boolean vert = false;//is up or down
    if (moveDirection.x ==1) {//right
      sortingVec = new PVector(3, 0);
      vert = false;
    } else if (moveDirection.x ==-1) {//left
      sortingVec = new PVector(0, 0);
      vert = false;
    } else if (moveDirection.y ==1) {//down
      sortingVec = new PVector(0, 3);
      vert = true;
    } else if (moveDirection.y ==-1) {//right
      sortingVec = new PVector(0, 0);
      vert = true;
    }

    for (int i = 0; i< 4; i++) {
      for (int j = 0; j<4; j++) {
        PVector temp = new PVector(sortingVec.x, sortingVec.y);
        if (vert) {
          temp.x += j;
        } else {
          temp.y += j;
        }
        sortingOrder.add(temp);
      }
      sortingVec.sub(moveDirection);
    }

    for (int j = 0; j< sortingOrder.size(); j++) {
      for (int i = 0; i< tiles.size(); i++) {
        if (tiles.get(i).position.x == sortingOrder.get(j).x && tiles.get(i).position.y == sortingOrder.get(j).y) {
          PVector moveTo = new PVector(tiles.get(i).position.x + moveDirection.x, tiles.get(i).position.y + moveDirection.y);
          int valueOfMoveTo = getValue(floor(moveTo.x), floor(moveTo.y));
          while (valueOfMoveTo == 0) {
            //tiles.get(i).position = new PVector(moveTo.x, moveTo.y); 
            tiles.get(i).moveTo(moveTo);
            moveTo = new PVector(tiles.get(i).positionTo.x + moveDirection.x, tiles.get(i).positionTo.y + moveDirection.y);
            valueOfMoveTo = getValue(floor(moveTo.x), floor(moveTo.y));
            tileMoved = true;
          }

          if (valueOfMoveTo == tiles.get(i).value) {
            //merge tiles
            Tile temp = getTile(floor(moveTo.x), floor(moveTo.y));



            if (!temp.alreadyIncreased) {

              tiles.get(i).moveTo(moveTo);
              tiles.get(i).deathOnImpact = true;


              //tiles.remove(i);
              temp.alreadyIncreased = true;
              tiles.get(i).alreadyIncreased = true;
              temp.value *=2;
              score += temp.value;
              temp.setColour();
              tileMoved = true;
            }
          }
        }
      }
    }
    if (tileMoved) {
      movingTheTiles = true;
    }
  }


  //------------------------------------------------------------------------------------------------------------------------------------

  void addNewTile() {


    PVector temp = emptyPositions.remove(floor(random(emptyPositions.size())));
    tiles.add(new Tile(floor(temp.x), floor(temp.y)));
  }


  void addNewTileNotRandom() {
    int notRandomNumber = score;// %
    for (int i = 0; i< tiles.size(); i++) {
      notRandomNumber += floor(tiles.get(i).position.x);
      notRandomNumber += floor(tiles.get(i).position.y);
      notRandomNumber += i;
    }

    int notRandomNumber2 = notRandomNumber %  emptyPositions.size();
    PVector temp = emptyPositions.remove(notRandomNumber2);
    tiles.add(new Tile(floor(temp.x), floor(temp.y)));

    if (notRandomNumber % 10 < 9) {
      tiles.get(tiles.size() -1).value = 2;
    } else {
      tiles.get(tiles.size() -1).value = 4;
    }

    tiles.get(tiles.size() -1).setColour();
  }


  //--------------------------------------------------------------------------------------------------------------------------
  int getValue(int x, int y) {
    if (x > 3 || x <0 || y>3 || y<0) { 
      return -1;
    }
    for (int i = 0; i< tiles.size(); i++) {
      if (tiles.get(i).positionTo.x == x && tiles.get(i).positionTo.y ==y) {
        return tiles.get(i).value;
      }
    }
    return 0;//means that its free
  }


  //----------------------------------------------------------------------------------------------------------------------------------
  Tile getTile(int x, int y) {
    for (int i = 0; i< tiles.size(); i++) {
      if (tiles.get(i).positionTo.x == x && tiles.get(i).positionTo.y ==y) {
        return tiles.get(i);
      }
    }

    return null;
  }


  //-----------------------------------------------------------------------------------------------------------------------------------
  void setStartState() {
    start = new State();
    //clone tiles
    for (int i = 0; i< tiles.size(); i++) {
      start.tiles.add(tiles.get(i).clone());
    }
    start.score = score;
    start.setEmptyPositions();
  }

//-------------------------------------------------------------------------------------------------------------------------------------
//gets the best move by looking x number of moves into the future.
  void getMove() {
    setStartState();
    start.getChildrenValues(0);
    switch(start.bestChild) {
    case 0 :
      moveDirection = new PVector(1, 0);
      break;
    case 1 :
      moveDirection = new PVector(-1, 0);
      break;
    case 2 :
      moveDirection = new PVector(0, 1);
      break;
    case 3 :
      moveDirection = new PVector(0, -1);
      break;
      
      
    }
    
    if(start.children[start.bestChild].value <= 0){
     setup(); 
    }
  }
}