class Snake{
  Network brain = new Network();
  PVector position = new PVector(10,10);

  ArrayList<Tile> snakeBlocks = new ArrayList<>();

  void draw(){

  }

  class Tile{
    PVector position = new PVector(0, 0);
  }
}
