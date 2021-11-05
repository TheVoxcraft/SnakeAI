import java.lang.Float;

class SnakeScene implements Comparable<SnakeScene>{

    float finalScore;
    int score = 0;
    int ticks = 0;

    int healthTicks = 140;

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
        
        if(!gameover){
            // Draw food
            fill(agent.col);
            rect(GRID_SIZE * foodPos.x, GRID_SIZE * foodPos.y, GRID_SIZE, GRID_SIZE);

            // Draw snake
            agent.draw();
        }
    }

    void tick(){
        if(!gameover){
            ticks++;
            healthTicks--;
            agent.setInputs(foodPos);
            agent.decide();
            agent.update();
            checkIfAgentScored();
            checkIfAgentCollided();
            calculateFinalScore();
            if(healthTicks <= 0){
                gameover = true;
            }
        }
    }

    void checkIfAgentScored(){
        // Checks if agent has eaten a piece of food
        // If so, add tail and score
        if(agent.position.dist(foodPos) < 0.001){
            randomizeFood();
            score++;
            healthTicks += 200;
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
        finalScore = 8*score*score + ticks/20f;
    }

    @Override
    public int compareTo(SnakeScene other) {
        calculateFinalScore();
        other.calculateFinalScore();
        Float s1 = (Float) finalScore;
        Float s2 = (Float) other.finalScore;
        return s1.compareTo(s2);
    }
    
}