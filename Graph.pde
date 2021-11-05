class Graph {
    ArrayList<Float> data = new ArrayList<>();
    int y;
    float boundingY;
    float scale;
    float maxValueInData = 90;
    color col;
    boolean linked = false;
    Graph linkedTo = null;

    Graph(int y, float bounding, float col_h){
        this.y = y;
        boundingY = bounding;
        scale = 1;
        col = color(col_h, 70, 90, 100);
    }

    void add(float p){
        data.add(p);
        if(!linked) updateScale();
    }

    void draw(){
        if(linked){
            scale = linkedTo.scale;
            maxValueInData = linkedTo.maxValueInData;
        }

        int xOffset = width - data.size();
        stroke(col);
        for(int i = max(0, data.size()-width); i < data.size(); i++){
            point(xOffset + i, y + (boundingY - data.get(i) * scale));
        }
        noStroke();
    }

    private void updateScale(){
        float maxVal = 0;
        for(int i = max(0, data.size()-width); i < data.size(); i++){
            if(data.get(i) > maxVal) maxVal = data.get(i);
        }
        maxValueInData = maxVal;

        scale = boundingY/maxValueInData;
    }

    void link(Graph g){
        if(g.linkedTo == this){
            println("Faliled to link: recursive links");
            return;
        }
        linked = true;
        linkedTo = g;
        scale = g.scale;
    }
}