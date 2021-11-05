class Snake{

  color col;

  float[] sensors = new float[12]; // Direction(4), DistToObstacle(4), VectorToFruit(2), DistToFruit(1), SnakeSize(1)
  Network brain;
  PVector position = new PVector(10,10);
  PVector actualDirection = new PVector(0, 0);
  PVector direction = new PVector(0, 1);

  PVector emptyTailBlockPos;
  ArrayList<TailBlock> snakeBlocks = new ArrayList<>();

  float snakeAlpha = 24;

  boolean isFollowed = false;

  float[] debug_lastInferOut = new float[] {0f,0f,0f,0f};

  Snake(int x, int y){
    position.set(x, y);
    snakeBlocks.add(new TailBlock(position, 0, -1));
    col = color(random(100), 80, 80, snakeAlpha);
    brain = new Network();
  }

  Snake(int x, int y, Network newBrain){
    position.set(x, y);
    snakeBlocks.add(new TailBlock(position, 0, -1));
    col = color(random(100), 80, 80, snakeAlpha);
    brain = newBrain;
  }

  void draw(){
    // Draw tail
    for(TailBlock b : snakeBlocks){
      drawBlock(b);
    }

    // Draw head
    float rx = position.x * GRID_SIZE;
    float ry = position.y * GRID_SIZE;
    fill(col);
    rect(rx, ry, GRID_SIZE, GRID_SIZE); 
    
  }
  
  void changeDirection(int x, int y){
    if((int)actualDirection.x == x*-1)  { return; }
    if((int)actualDirection.y == y*-1)  { return; }
    direction.set(x, y);
  }

  boolean isObstacle(int x, int y){
    if(x < 0 || y < 0){
        return true;
    }
    if(x > MAX_BOARD_WIDTH || y > MAX_BOARD_HEIGHT){
        return true;
    }
    if(isCollidedWithSelf(new PVector(x, y))){
        return true;
    }
    return false;
  }

  void setInputs(PVector fruit){
    //TODO: Check that these inputs are correct
    
    // Reset sensors
    for(int i = 0; i < sensors.length; i++){
      sensors[i] = 0f;
    }

    // Set direction
    PVector ad = actualDirection;
    if(ad.x == 1 && ad.y == 0)  sensors[0] = 1;
    if(ad.x == -1 && ad.y == 0) sensors[1] = 1;
    if(ad.x == 0 && ad.y == 1)  sensors[2] = 1;
    if(ad.x == 0 && ad.y == -1) sensors[3] = 1;


    // Set DistToObstacle(4)
    float[] distToObs = new float[4];
    int count = 0;
    for(int i = -1; i <= 1; i++){
      for(int j = -1; j <= 1; j++){
        if(abs(i) == abs(j) && abs(i) == 1) continue;
        if(i == j && i == 0) continue;
        int d = 1;
        while(!isObstacle((int)position.x+(i * d), (int)position.y+(j * d))){
          d++;
          if(d > 40) break;
        }
        
        distToObs[count] = d / 40f;
        count++;
      }
    }
    sensors[4] = distToObs[0];
    sensors[5] = distToObs[1];
    sensors[6] = distToObs[2];
    sensors[7] = distToObs[3];

    // Set vector to fruit
    PVector vecToFruit = new PVector(position.x-fruit.x, position.y-fruit.y);
    vecToFruit.normalize();
    sensors[8] = (vecToFruit.x+1)/2;
    sensors[9] = (vecToFruit.y+1)/2;

    // Set dist to fruit
    sensors[10] = position.dist(fruit)/56f;

    // Set snake size
    sensors[11] = snakeBlocks.size() / 10f;
  }

  void decide(){
    float[] out = brain.infer(sensors);
    debug_lastInferOut = out;
    int dirType = 0;
    float max = 0;
    for(int i = 0; i < out.length; i++){
      if(out[i] > max){
        dirType = i;
        max = out[i];
      }
    }

    PVector nd = new PVector(0, 0);
    if(dirType == 0) nd.set(1, 0);
    if(dirType == 1) nd.set(-1, 0);
    if(dirType == 2) nd.set(0, 1);
    if(dirType == 3) nd.set(0, -1);

    changeDirection((int)nd.x, (int)nd.y);
  }

  void update(){
    // Updates head and neck
    PVector old = new PVector(snakeBlocks.get(0).position.x, snakeBlocks.get(0).position.y);
    snakeBlocks.get(0).position.set(position);
    position.add(direction);
    
    // Updates tail
    for(int i = 1; i < snakeBlocks.size(); i++){
      PVector temp = new PVector(snakeBlocks.get(i).position.x, snakeBlocks.get(i).position.y);
      snakeBlocks.get(i).position.set(old);
      old = temp;
    }
    emptyTailBlockPos = new PVector(0, 0);
    emptyTailBlockPos.set(old);

    actualDirection.set(direction);
  }

  void extendTail(){
    snakeBlocks.add(new TailBlock(emptyTailBlockPos));
  }

  void drawBlock(TailBlock b){
    fill(col);
    float rx = b.position.x * GRID_SIZE;
    float ry = b.position.y * GRID_SIZE;
    rect(rx, ry, GRID_SIZE, GRID_SIZE);
  }

  boolean isCollidedWithSelf(){
    for(TailBlock b : snakeBlocks){
      if(position.dist(b.position) < 0.001){
        return true;
      }
    }
    return false;
  }

  boolean isCollidedWithSelf(PVector other){
    for(TailBlock b : snakeBlocks){
      if(other.dist(b.position) < 0.001){
        return true;
      }
    }
    return false;
  }

  class TailBlock {
      PVector position;
      TailBlock(PVector snakePos, int relx, int rely){
        position = new PVector(snakePos.x+(float)relx, snakePos.y+(float)rely);
      }

      TailBlock(PVector pos){
        position = new PVector(pos.x, pos.y);
      }
  }
}
