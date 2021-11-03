import java.util.*;

int POPULATION_SIZE = 300;

int GRID_SIZE = 20;
int MAX_BOARD_WIDTH;
int MAX_BOARD_HEIGHT;

float SNAKE_UPDATE_RATE = 60; // snake updates per second
int BATCH_SNAKE_UPDATES = 3;
float elapsedTimeSinceUpdate = Float.MAX_VALUE;
int currentGeneration = 0;

SnakeScene followingBestScene;

boolean DEBUGGING = true;

ArrayList<SnakeScene> scenes = new ArrayList<>();

void setup(){
  frameRate(90);
  size(800, 800);
  colorMode(HSB, 100);
  MAX_BOARD_WIDTH = (int) width / GRID_SIZE;
  MAX_BOARD_HEIGHT = (int) height / GRID_SIZE;

  for(int i = 0; i < POPULATION_SIZE; i++){
    scenes.add(new SnakeScene());
  }

  followingBestScene = scenes.get(0);
  followingBestScene.agent.col = color(25, 100, 100, 100);
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
    drawDebugTextEvolution();
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

  if(allDead){ // All snakes dead, generate next generation
    nextGeneration();
  }
}


void nextGeneration(){
  currentGeneration++;
  // Sort snakes after score and ticks alive, DESC
  Collections.sort(scenes); // Java 8 Alternative : scenes.sort(Comparator.comparing(SnakeScene::finalScore).reversed());
  Collections.reverse(scenes);

  println("G"+currentGeneration+" - Best score: "+scenes.get(0).finalScore);

  // Make new population with best half of population (Reproduction & TODO: Crossover)
  ArrayList<SnakeScene> newScenes = new ArrayList<>();
  for(int i = 0; i < scenes.size()/2; i++){
    SnakeScene old = scenes.get(i);
    Network newBrain = old.agent.brain.Reproduce();
    SnakeScene newScene = new SnakeScene(newBrain);
    newScenes.add(newScene);
  }
  followingBestScene = newScenes.get(0); // Gets best snake from previous generation
  followingBestScene.agent.col = color(66, 100, 100, 100);

  // Make completely new half
  for(int i = 0; i < scenes.size()/2; i++){
    SnakeScene newScene = new SnakeScene(); // Random network snakes
    newScenes.add(newScene);
  }

  // Reset evolution and start it
  scenes = newScenes;
}

void drawDebugTextEvolution(){
  TextBox t = new TextBox(20, 23, 19);
  t.addText("Framerate: " + (int)frameRate);
  t.addText("Pop Size: " + POPULATION_SIZE);
  t.addText("Generation: " + currentGeneration);
  t.addText("PrevBestSnake.score: "+followingBestScene.score);
  t.addText("PrevBestSnake.health: "+followingBestScene.healthTicks);
  t.addText("PrevBestSnake.isDead: "+followingBestScene.gameover);
  fill(0, 0, 90, 90);
  t.draw();
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