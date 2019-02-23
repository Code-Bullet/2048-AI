class State {
  State[] children = new State[4];
  float value = 0;
  int score = 0;

  ArrayList<Tile> tiles = new ArrayList<Tile>();
  ArrayList<PVector> emptyPositions = new ArrayList<PVector>();
  boolean differentFromParent = false;
  boolean dead =false;
  int bestChild =0;

  State() {
  }



  State clone() {
    State clone = new State();
    //clone tiles
    for (int i = 0; i< tiles.size(); i++) {
      clone.tiles.add(tiles.get(i).clone());
    }
    clone.score = score;
    clone.setEmptyPositions();
    return clone;
  }

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


  void move(int x, int y) {
    PVector moveDirection = new PVector(x, y);
    differentFromParent = false;
    for (int i = 0; i< tiles.size(); i++) {
      tiles.get(i).alreadyIncreased = false;
    }
    ArrayList<PVector> sortingOrder = new ArrayList<PVector>();
    PVector sortingVec = new PVector();
    boolean vert = false;//is up or down
    if (x ==1) {//right
      sortingVec = new PVector(3, 0);
      vert = false;
    } else if (x ==-1) {//left
      sortingVec = new PVector(0, 0);
      vert = false;
    } else if (y ==1) {//down
      sortingVec = new PVector(0, 3);
      vert = true;
    } else if (y ==-1) {//right
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
            tiles.get(i).moveToNow(moveTo);
            moveTo = new PVector(tiles.get(i).position.x + moveDirection.x, tiles.get(i).position.y + moveDirection.y);
            valueOfMoveTo = getValue(floor(moveTo.x), floor(moveTo.y));
            differentFromParent = true;
          }

          if (valueOfMoveTo == tiles.get(i).value) {
            //merge tiles
            Tile temp = getTile(floor(moveTo.x), floor(moveTo.y));



            if (!temp.alreadyIncreased) {

              tiles.get(i).moveToNow(moveTo);
              tiles.get(i).deathOnImpact = true;


              //tiles.remove(i);
              temp.alreadyIncreased = true;
              tiles.get(i).alreadyIncreased = true;
              temp.value *=2;
              score += temp.value;
              temp.setColour();
              differentFromParent = true;
            }
          }
        }
      }
    }
    if (differentFromParent) {

      addNewTileNotRandom();
    } else {
      dead= true;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------

  void addNewTile() {


    PVector temp = emptyPositions.remove(floor(random(emptyPositions.size())));
    tiles.add(new Tile(floor(temp.x), floor(temp.y)));
  }


  void addNewTileNotRandom() {

    setEmptyPositions();
    if (emptyPositions.size() ==0) {
      dead = true; 
      return;
    }
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
      if (tiles.get(i).position.x == x && tiles.get(i).position.y ==y) {
        return tiles.get(i).value;
      }
    }
    return 0;//means that its free
  }


  //----------------------------------------------------------------------------------------------------------------------------------
  Tile getTile(int x, int y) {
    for (int i = 0; i< tiles.size(); i++) {
      if (tiles.get(i).position.x == x && tiles.get(i).position.y ==y) {
        return tiles.get(i);
      }
    }
    return null;
  }
  //-------------------------------------------------------------------------------------------------------------------------------------

  void setValue() {
    if (dead) {
      value =0;
      return;
    }
    value = 0;
    value += score;
    value += random(1000);
    
    //for (int i = 0; i< tiles.size(); i++) {
    //  for (int j = 0; j< tiles.size(); j++) {
    //    if (i != j && dist(tiles.get(i).position.x, tiles.get(i).position.y, tiles.get(j).position.x, tiles.get(j).position.y) <= 1) {
    //      //tiles whihc are adjacent are good
    //      if (tiles.get(i).value == tiles.get(j).value) {
    //        value += tiles.get(i).value/2;
    //      }

    //      //have adjacent things be close in value
    //      if (tiles.get(i).value == tiles.get(j).value/2) {
    //        value += tiles.get(i).value/4;
    //      } else  if (tiles.get(j).value == tiles.get(i).value/2) {
    //        value += tiles.get(j).value/4;
    //      }
    //    }
    //  }
    //}
    ////value empty spaces  
    //value*= (1.0+(emptyPositions.size() * 0.05));
    //int max = 0 ;
    //int maxTile = 0;
    //for (int i = 0; i< tiles.size(); i++) {
    //  if (tiles.get(i).value > max) {
    //    max = tiles.get(i).value;
    //    maxTile = i;
    //  }
    //}

    //if (tiles.get(maxTile).position.y ==0) {
    //  value *= 1.5;
    //  if (tiles.get(maxTile).position.x ==0) {
    //    value *=3;
    //    max = 0;
    //    int secondBest = 0;
    //    for (int i = 0; i< tiles.size(); i++) {
    //      if (i != maxTile && tiles.get(i).value > max) {
    //        max = tiles.get(i).value;
    //        secondBest = i;
    //      }
    //    }
    //    if (tiles.get(secondBest).position.y ==0 && tiles.get(secondBest).position.x ==1) {
    //      value *= 1.2;
    //      max = 0;
    //      int thirdBest = 0;
    //      for (int i = 0; i< tiles.size(); i++) {
    //        if (i != maxTile && i != secondBest && tiles.get(i).value > max) {
    //          max = tiles.get(i).value;
    //          thirdBest = i;
    //        }
    //      }
    //      if (tiles.get(thirdBest).position.y ==0 && tiles.get(thirdBest).position.x ==2) {
    //        value *= 1.2;
    //      }
    //    }
    //  }
    //} 
  }


  //---------------------------------------------------------------------------------------------------------------------------------------

  float getChildrenValues(int depth) {
    if (depth >= maxDepth) {
      setValue();
      return value;
    }

    for (int i = 0; i< 4; i++) {
      children[i] = clone();
    }

    children[0].move(1, 0);

    children[1].move(-1, 0);

    children[2].move(0, 1);

    children[3].move(0, -1);

    for (int i = 0; i< 4; i++) {
      if (!children[i].differentFromParent) {
        children[i].dead = true;
      }
    }



    float max = 0;
    int maxChild =0;
    for (int i = 0; i  < 4; i++) {
      if (!children[i].dead) {
        float temp = children[i].getChildrenValues(depth+1) ;

//        if (i == 2) {
//          temp *= 0.5;
//        }
        if (depth ==0) {
          println("Child " + i + "gets a value of " + temp);
        }
        if (temp > max) {
          max =  temp;
          maxChild = i;
        }
      }
    }


    bestChild = maxChild;
    
    setValue();
    if(max < value){
     return value; 
    }
    return max;
  }
}