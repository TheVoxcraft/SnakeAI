import java.util.*;

int POPULATION_SIZE = 500;

int GRID_SIZE = 20;
int MAX_BOARD_WIDTH;
int MAX_BOARD_HEIGHT;

float SNAKE_UPDATE_RATE = 60; // snake updates per second
int BATCH_SNAKE_UPDATES = 10;

float elapsedTimeSinceUpdate = Float.MAX_VALUE;
int currentGeneration = 0;

SnakeScene followingBestScene;

boolean DEBUGGING = true;
Graph debugBestScoreGraph;
Graph debugAvgScoreGraph;
UseMode useMode = UseMode.Default;
String useModeText = "Default";

public enum UseMode {
  Default,
  Showcase,
  Follow,
  Hypertraining
}

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

  followingBestScene = scenes.get(0);
  followingBestScene.agent.col = color(25, 100, 100, 100);

  debugBestScoreGraph = new Graph(0);
  debugAvgScoreGraph = new Graph(30);
}

void draw(){
  background(11);

  if(useMode == UseMode.Follow){
    while(followingBestScene.gameover){
      update();
    }
    followingBestScene.draw();
  } else {
    drawAllScenes();
  }

  
  update(); // Code for updating all scenes
  
  if(useMode == UseMode.Hypertraining){
    useModeText = "Hypertraining ("+(int)(frameRate*BATCH_SNAKE_UPDATES)+")";
    if(frameRate > 50) BATCH_SNAKE_UPDATES += 5;
    if(frameRate <= 45) BATCH_SNAKE_UPDATES -= 1;
  }

  if(DEBUGGING){
    drawDebugScoreGraph();
    drawDebugTextEvolution();
    drawDebugTextBestSnake();
    drawDebugSnakeNetwork(followingBestScene.agent.brain);
  }
}

void update(){
  if(elapsedTimeSinceUpdate >= 1/SNAKE_UPDATE_RATE || SNAKE_UPDATE_RATE >= 60){
      for(int i = 0; i < BATCH_SNAKE_UPDATES; i++){
        updateAllScenes();
      }
      elapsedTimeSinceUpdate = 0;
    } else {
      float dt = 60.0/frameRate;
      elapsedTimeSinceUpdate += dt/60.0;
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

  //println("G"+currentGeneration+" - Best score: "+scenes.get(0).finalScore);
  debugBestScoreGraph.add(scenes.get(0).finalScore);

  // Make new population with best half of population (Reproduction & TODO: Crossover)
  ArrayList<SnakeScene> newScenes = new ArrayList<>();
  float totalScore = 0;
  for(int i = 0; i < scenes.size()/2; i++){
    SnakeScene old = scenes.get(i);
    totalScore += old.finalScore;
    Network newBrain = old.agent.brain.Reproduce();
    SnakeScene newScene = new SnakeScene(newBrain);
    newScenes.add(newScene);
  }
  followingBestScene = newScenes.get(0); // Gets best snake from previous generation
  followingBestScene.agent.col = color(34, 100, 100, 100);
  followingBestScene.agent.isFollowed = true;
  
  float avgScore = totalScore/(POPULATION_SIZE/2);
  //println("Avg: "+avgScore);
  debugAvgScoreGraph.add(avgScore);

  // Make completely new half
  for(int i = 0; i < scenes.size()/2; i++){
    SnakeScene newScene = new SnakeScene(); // Random network snakes
    newScenes.add(newScene);
  }

  // Reset evolution and start it
  scenes = newScenes;
}

void drawDebugScoreGraph(){
   debugBestScoreGraph.draw();
   debugAvgScoreGraph.draw();
}

void drawDebugTextEvolution(){
  TextBox t = new TextBox(20, 23, 17);
  t.addText("Framerate: " + (int)frameRate);
  t.addText("Pop Size: " + POPULATION_SIZE);
  t.addText("Generation: " + currentGeneration);
  t.addText("Use Mode: "+useModeText);
  fill(0, 0, 90, 90);
  t.draw();
}

void drawDebugTextBestSnake(){
  TextBox t = new TextBox(20, 100, 17);
  t.addText("Follow.finalScore: "+followingBestScene.finalScore);
  t.addText("Follow.health: "+followingBestScene.healthTicks);
  t.addText("Follow.isDead: "+followingBestScene.gameover);
  t.addText("Follow.inferenceInput: " + Arrays.toString(followingBestScene.agent.sensors));
  t.addText("Follow.inferenceOutput: " + Arrays.toString(followingBestScene.agent.debug_lastInferOut));
  fill(0, 0, 80, 70);
  t.draw();
}


void drawDebugSnakeNetwork(Network snakeBrain){
  int x = 170;
  int y = 20;

  fill(0,0,100,70);
  mxu.drawMatrix(snakeBrain.d_prevInput, x, y, 10, 10);
  mxu.drawMatrix(snakeBrain.d_prevHidden, x+45, y, 10, 10);
  mxu.drawMatrix(snakeBrain.d_prevOut, x+90, y, 10, 10);

  /* Drawing hidden weights 
  fill(66,10,100,40);
  mxu.drawMatrix(snakeBrain.weights_ih, x+40, y, 32, 10);
  mxu.drawMatrix(snakeBrain.weights_ho, x+120, y+80, 32, 10);
  */
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


void keyPressed(){
  if (key == 'a'){
    useMode = UseMode.Default;
    useModeText = "Default";
    SNAKE_UPDATE_RATE = 60;
    BATCH_SNAKE_UPDATES = 1;
  }
  if(key == 's'){
    useMode = UseMode.Showcase;
    useModeText = "Showcase";
    SNAKE_UPDATE_RATE = 25;
    BATCH_SNAKE_UPDATES = 1;
  }
  if(key == 'f'){
    useMode = UseMode.Follow;
    useModeText = "Following";
    SNAKE_UPDATE_RATE = 30;
    BATCH_SNAKE_UPDATES = 1;
  }
  if (key == 'd'){
    useMode = UseMode.Hypertraining;
    useModeText = "Hypertraining ("+BATCH_SNAKE_UPDATES+")";
    SNAKE_UPDATE_RATE = 60;
    BATCH_SNAKE_UPDATES = 30;
  }
}