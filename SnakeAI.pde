int POPULATION_SIZE = 20;

int GRID_SIZE = 20;
int MAX_BOARD_WIDTH;
int MAX_BOARD_HEIGHT;

float SNAKE_UPDATE_RATE = 10; // snake updates per second
int BATCH_SNAKE_UPDATES = 1;
float elapsedTimeSinceUpdate = Float.MAX_VALUE;

boolean DEBUGGING = true;

ArrayList<SnakeScene> scenes = new ArrayList<>();

void setup(){
  frameRate(60);
  size(800, 800);
  colorMode(HSB, 100);
  MAX_BOARD_WIDTH = (int) width / GRID_SIZE;
  MAX_BOARD_HEIGHT = (int) height / GRID_SIZE;

  for(int i = 0; i < POPULATION_SIZE; i++){
    scenes.add(new SnakeScene());
  }
}

void draw(){
  background(11);

  drawAllScenes();

  if(elapsedTimeSinceUpdate >= 1/SNAKE_UPDATE_RATE || SNAKE_UPDATE_RATE >= 60){
    for(int i = 0; i < BATCH_SNAKE_UPDATES; i++){
      updateAllScenes();
    }
    elapsedTimeSinceUpdate = 0;
  } else {
    float dt = 60.0/frameRate;
    elapsedTimeSinceUpdate += dt/60.0;
  }

  
  if(DEBUGGING){
    // drawDebugText(scene);
  }
}

void drawAllScenes(){
  for(int i = 0; i < POPULATION_SIZE; i++){
    scenes.get(i).draw();
  }
}

void updateAllScenes(){
  boolean allDead = true;
  for(int i = 0; i < POPULATION_SIZE; i++){
    SnakeScene sc = scenes.get(i);
    sc.tick();
    if(!sc.gameover) allDead = false; // Someones still alive
  }
  if(allDead){
    println("All dead snakes");

    // TODO:
    // Sort snakes after score and ticks alive
    // Java 8 Alternative: users.sort(Comparator.comparing(User::getCreatedOn).reversed());
    ArrayList<SnakeScene> newScenes = new ArrayList<>();
    Collections.sort(scenes);
    Collections.reverse(scenes);
    for(int i = 0; i < scenes.size()/2; i++){
      SnakeScene old = scenes.get(i);
      Network newBrain = old.brain.Reproduce();
      SnakeScene newScene = new SnakeScene();

    }
    // Make new population with best half of population (Reproduction & Crossover)
    // Make completely new half
    // Reset scenes
  }
}

void drawDebugTextScene(SnakeScene scene){
  TextBox t = new TextBox(20, 23, 19);
  t.addText("Framerate: "+(int)frameRate);
  t.addText("Scene.Tick: "+scene.ticks);
  t.addText("Scene.Score: "+scene.score);
  t.addText("Scene.Agent: "+scene.agent.position.x+", "+scene.agent.position.y);
  t.addText("Scene.Food: "+scene.foodPos.x+", "+scene.foodPos.y);
  t.addText("Scene.GameOver: "+!scene.gameover);
  fill(220);
  t.draw();
}

/* Debug: Player input
void keyPressed(){
  if(key == CODED){
    if (keyCode == LEFT){
      scene.agent.changeDirection(-1, 0);
    }
    if(keyCode == RIGHT){
      scene.agent.changeDirection(1, 0);
    }
    if (keyCode == UP){
      scene.agent.changeDirection(0, -1);
    }
    if(keyCode == DOWN){
      scene.agent.changeDirection(0, 1);
    }
  }
}*/