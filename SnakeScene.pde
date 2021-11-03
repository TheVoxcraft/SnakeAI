class SnakeScene implements Comparable<SnakeScene>{

    float finalScore;
    int score = 0;
    int ticks = 0;

    Snake agent;
    PVector foodPos = new PVector(10, 30);

    boolean gameover = false;

    SnakeScene(){
        int x = (int)random(width/GRID_SIZE-1);
        int y = (int)random(height/GRID_SIZE-1);
        agent = new Snake(x, y);
        randomizeFood();
    }

    SnakeScene(Network newBrain){
        int x = (int)random(width/GRID_SIZE-1);
        int y = (int)random(height/GRID_SIZE-1);
        agent = new Snake(x, y, newBrain);
        randomizeFood();
    }

    void randomizeFood(){
        int x = (int)random(width/GRID_SIZE-1);
        int y = (int)random(height/GRID_SIZE-1);
        foodPos.set(x, y);
    }

    void draw(){
        noStroke();

        // Draw food
        fill(agent.col);
        rect(GRID_SIZE * foodPos.x, GRID_SIZE * foodPos.y, GRID_SIZE, GRID_SIZE);

        // Draw snake
        agent.draw();
        
    }

    void tick(){
        if(!gameover){
            ticks++;
            agent.setInputs(foodPos);
            agent.decide();
            agent.update();
            checkIfAgentScored();
            checkIfAgentCollided();
        }
    }

    void checkIfAgentScored(){
        // Checks if agent has eaten a piece of food
        // If so, add tail and score
        if(agent.position.dist(foodPos) < 0.001){
            randomizeFood();
            score++;
            agent.extendTail();
        }
    }

    void checkIfAgentCollided(){
        if(agent.position.x < 0 || agent.position.y < 0){
            gameover = true;
        }
        if(agent.position.x > MAX_BOARD_WIDTH || agent.position.y > MAX_BOARD_HEIGHT){
            gameover = true;
        }
        if(agent.isCollidedWithSelf()){
            gameover = true;
        }
        if(gameover) calculateFinalScore();
    }

    void calculateFinalScore(){
        finalScore = score**2 + ticks/10f;
    }

    @Override
    public int compareTo(SnakeScene other) {
        return finalScore.compareTo(other.finalScore);
    }
    
}