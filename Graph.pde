class Graph {
    ArrayList<Float> data = new ArrayList<>();
    int boundingBoxHeight = 100;
    int maxDataValue = 50;
    color col;

    Graph(float col_h){
        col = color(col_h, 70, 90, 100);
    }

    void add(float p){
        data.add(p);
    }

    void draw(){
        int xOffset = width - data.size();
        stroke(col);
        for(int i = max(0, data.size()-width); i < data.size(); i++){
            point(xOffset + i, maxDataValue + data.get(i));
        }
        noStroke();
    }
}